module httpc

using libCURL
using mime_ext

export init, cleanup, get, put, put_file, post, post_file, trace, delete, head, options
export Response, ContentType

import Base.convert

typealias Callback Union(Function,Bool)
typealias ContentType Union(String,Bool)

default_timeout = 30.0


##############################
# Struct definitions
##############################

type Response
    body
    headers
    http_code
    total_time
    
    Response() = new("", Dict{ASCIIString, ASCIIString}(), 0, 0.0)
end


type ReadData
    typ::Symbol
    fd::Union(IOStream, Bool)
    str::String
    offset::Int
    sz::Int

    ReadData() = new(:undefined, false, "", 0, 0)
end

type ConnContext
    curl::Ptr{CURL}
    slist::Ptr{Void}
    rd::ReadData
    resp::Response
    timeout::Float64
    cb::Callback
    content_type::ContentType
    
    ConnContext() = new(0, 0, ReadData(), Response(), default_timeout, false, false)
end

immutable CURLMsg2
  msg::CURLMSG
  easy_handle::Ptr{CURL}
  data::Ptr{Any}
end


##############################
# Callbacks
##############################

function write_cb(buff::Ptr{Uint8}, sz::Uint32, n::Uint32, p_ctxt::Ptr{Void})
#    println("@write_cb")
    ctxt = unsafe_pointer_to_objref(p_ctxt)
    ctxt.resp.body = ctxt.resp.body * bytestring(buff, convert(Int32, sz * n))
    sz*n
end

c_write_cb = cfunction(write_cb, Uint32, (Ptr{Uint8}, Uint32, Uint32, Ptr{Void}))

function header_cb(buff::Ptr{Uint8}, sz::Uint32, n::Uint32, p_ctxt::Ptr{Void})
#    println("@header_cb")
    ctxt = unsafe_pointer_to_objref(p_ctxt)
    hdrlines = split(bytestring(buff, convert(Int32, sz * n)), "\r\n")

#    println(hdrlines)
    for e in hdrlines
        m = match(r"^\s*([\w\-\_]+)\s*\:(.+)", e)
        if (m != nothing) 
            ctxt.resp.headers[strip(m.captures[1])] = strip(m.captures[2])
        end
    end
    sz*n
end

c_header_cb = cfunction(header_cb, Uint32, (Ptr{Uint8}, Uint32, Uint32, Ptr{Void}))




function curl_read_cb(out::Ptr{Void}, s::Csize_t, n::Csize_t, p_ctxt::Ptr{Void})
#    println("@curl_read_cb")

    ctxt = unsafe_pointer_to_objref(p_ctxt)
    bavail = s * n
    breq = ctxt.rd.sz - ctxt.rd.offset
    b2copy = bavail > breq ? breq : bavail

#    println("$b2copy, $s, $n, $bavail, $breq, $(ctxt.rd.sz), $(ctxt.rd.offset)")
    if (ctxt.rd.typ == :buffer)
        ccall(:memcpy, Ptr{Void}, (Ptr{Void}, Ptr{Void}, Uint),
                out, convert(Ptr{Uint8}, ctxt.rd.str) + ctxt.rd.offset, b2copy)
    elseif (ctxt.rd.typ == :io)
        b_read = read(ctxt.rd.fd, Uint8, b2copy)
        ccall(:memcpy, Ptr{Void}, (Ptr{Void}, Ptr{Void}, Uint), out, b_read, b2copy)
    end
    ctxt.rd.offset = ctxt.rd.offset + b2copy

    r = convert(Csize_t, b2copy)
    r::Csize_t
end

c_curl_read_cb = cfunction(curl_read_cb, Csize_t, (Ptr{Void}, Csize_t, Csize_t, Ptr{Void}))


##############################
# Utility functions
##############################

macro ce_curl (f, args...)
    quote
        cc = CURLE_OK
        cc = $(esc(f))(ctxt.curl, $(args...)) 
        
        if(cc != CURLE_OK)
            error (string($f) * "() failed: " * bytestring(curl_easy_strerror(cc)))
        end
    end    
end

function get_ct_from_ext(filename)
    fparts = split(basename(filename), ".")
    if (length(fparts) > 1)
        if has(MimeExt, fparts[end]) return MimeExt[fparts[end]] end
    end
    return false
end


function setup_easy_handle(url, timeout::Float64, cb::Callback, content_type::ContentType)
    ctxt = ConnContext()
    ctxt.timeout = timeout
    ctxt.cb = cb
    ctxt.content_type = content_type
    
    curl = curl_easy_init()
    if (curl == 0) throw("curl_easy_init() failed") end

    ctxt.curl = curl

    @ce_curl curl_easy_setopt CURLOPT_FOLLOWLOCATION 1

    @ce_curl curl_easy_setopt CURLOPT_MAXREDIRS 5

    @ce_curl curl_easy_setopt CURLOPT_URL url
    @ce_curl curl_easy_setopt CURLOPT_WRITEFUNCTION c_write_cb

    p_ctxt = pointer_from_objref(ctxt)

    @ce_curl curl_easy_setopt CURLOPT_WRITEDATA p_ctxt

    @ce_curl curl_easy_setopt CURLOPT_HEADERFUNCTION c_header_cb
    @ce_curl curl_easy_setopt CURLOPT_HEADERDATA p_ctxt

    if isa(content_type, String)
        ct = "Content-Type: " * content_type
        ctxt.slist = curl_slist_append (ctxt.slist, ct)
    end
    
    ctxt
end

function cleanup_easy_context(ctxt::Union(ConnContext,Bool))
    if isa(ctxt, ConnContext)
        if (ctxt.slist != 0)
            curl_slist_free_all(ctxt.slist)
        end

        if (ctxt.curl != 0)
            curl_easy_cleanup(ctxt.curl)
        end
    end
end


function process_response(ctxt)
    http_code = Array(Int,1)
    @ce_curl curl_easy_getinfo CURLINFO_RESPONSE_CODE http_code
    
    total_time = Array(Float64,1)
    @ce_curl curl_easy_getinfo CURLINFO_TOTAL_TIME total_time

    ctxt.resp.http_code = http_code[1]
    ctxt.resp.total_time = total_time[1]
    
end

# function blocking_get (url)
#     try
#         ctxt=nothing
#         ctxt = setup_easy_handle(url)
#         curl = ctxt.curl
# 
#         @ce_curl curl_easy_perform
# 
#         process_response(ctxt)
# 
#         return ctxt.resp
#     finally
#         if isa(ctxt, ConnContext) && (ctxt.curl != 0)
#             curl_easy_cleanup(ctxt.curl)
#         end
#     end
# end





##############################
# Library initializations
##############################

init() = curl_global_init(CURL_GLOBAL_ALL)
cleanup() = curl_global_cleanup()


##############################
# GET
##############################

function get(url::String; timeout=default_timeout, cb=false)
    ctxt = false
    try
        ctxt = setup_easy_handle(url, timeout, cb, false)
        
        @ce_curl curl_easy_setopt CURLOPT_HTTPGET 1
        
        return exec_as_multi(ctxt)
    finally
        cleanup_easy_context(ctxt)
    end
end


##############################
# POST & PUT
##############################

post (url::String, data::String; content_type=false, timeout=default_timeout, cb=false) = put_post(url, :post, data, content_type, timeout, cb)
put (url::String, data::String; content_type=false, timeout=default_timeout, cb=false) = put_post(url, :put, data, content_type, timeout, cb)

function put_post(url::String, putorpost::Symbol, data::String, content_type=false, timeout=default_timeout, cb=false)
    rd::ReadData = ReadData()
    rd.typ = :buffer
    rd.str = data
    rd.offset = 0
    rd.sz = length(data)

    _put_post(url, putorpost, content_type, timeout, cb, rd)
end


post_file (url::String, filename::String; content_type=false, timeout=default_timeout, cb=false) = put_post_file(url, :post, filename, content_type, timeout, cb)
put_file (url::String, filename::String; content_type=false, timeout=default_timeout, cb=false) = put_post_file(url, :put, filename, content_type, timeout, cb)

function put_post_file(url::String, putorpost::Symbol, filename::String, content_type=false, timeout=default_timeout, cb=false)
    rd::ReadData = ReadData()
    rd.typ = :io
    rd.offset = 0
    rd.fd = open(filename)
    rd.sz = filesize(filename)

    try
        if (content_type == false) content_type = get_ct_from_ext(filename) end
        return _put_post(url, putorpost, content_type, timeout, cb, rd)
    finally
        close(rd.fd)
    end
end



function _put_post(url::String, putorpost::Symbol, content_type::ContentType, timeout::Float64, cb::Callback, rd::ReadData)
    ctxt = false
    try
        ctxt = setup_easy_handle(url, timeout, cb, content_type)
        ctxt.rd = rd

        if (putorpost == :post)
            @ce_curl curl_easy_setopt CURLOPT_POST 1
            @ce_curl curl_easy_setopt CURLOPT_POSTFIELDSIZE rd.sz
        elseif (putorpost == :put)
            @ce_curl curl_easy_setopt CURLOPT_UPLOAD 1
            @ce_curl curl_easy_setopt CURLOPT_INFILESIZE rd.sz
        end

        if (rd.typ == :io) || (putorpost == :put)
            p_ctxt = pointer_from_objref(ctxt)
            @ce_curl curl_easy_setopt CURLOPT_READDATA p_ctxt

            @ce_curl curl_easy_setopt CURLOPT_READFUNCTION c_curl_read_cb
        else
            ppostdata = pointer(convert(Array{Uint8}, rd.str), 1)
            @ce_curl curl_easy_setopt CURLOPT_COPYPOSTFIELDS ppostdata
        end

        # Disabling the Expect header since some webservers don't handle this properly
        ctxt.slist = curl_slist_append (ctxt.slist, "Expect:")
        @ce_curl curl_easy_setopt CURLOPT_HTTPHEADER ctxt.slist

        return exec_as_multi(ctxt)
    finally
        cleanup_easy_context(ctxt)
    end
end



##############################
# HEAD, DELETE and TRACE
##############################

function head(url::String; timeout=default_timeout, cb=false)
    ctxt = false
    try
        ctxt = setup_easy_handle(url, timeout, cb, false)

        @ce_curl curl_easy_setopt CURLOPT_NOBODY 1

        return exec_as_multi(ctxt)
    finally
        cleanup_easy_context(ctxt)
    end
end

delete(url::String, timeout=default_timeout, cb=false) = custom(url, "DELETE", timeout, cb)
trace(url::String, timeout=default_timeout, cb=false) = custom(url, "TRACE", timeout, cb)
options(url::String, timeout=default_timeout, cb=false) = custom(url, "OPTIONS", timeout, cb)

function custom(url::String, verb::String, timeout::Float64, cb::Callback)
    ctxt = false
    try
        ctxt = setup_easy_handle(url, timeout, cb, false)

        @ce_curl curl_easy_setopt CURLOPT_CUSTOMREQUEST verb

        return exec_as_multi(ctxt)
    finally
        cleanup_easy_context(ctxt)
    end
end



function exec_as_multi(ctxt)
    curl = ctxt.curl
    curlm = curl_multi_init()
    
    if (curlm == 0) error("Unable to initialize curl_multi_init()") end

    try
        if isa(ctxt.cb, Function) ctxt.cb(curl) end
    
        cmc = curl_multi_add_handle(curlm, curl)
        if(cmc != CURLM_OK) error ("curl_multi_add_handle() failed: " * curl_multi_strerror(cmc)) end

        n_active = Array(Int,1)
        n_active[1] = 1
        now  = int64(time()*1000)
        till = now + int64(ctxt.timeout * 1000) + 1
        
        cmc = curl_multi_perform(curlm, n_active);
        while (n_active[1] > 0) && ((till - now) > 0)
            sleep(0.025)   # 25 milliseconds
#            println("@sleep")
            
            cmc = curl_multi_perform(curlm, n_active);    
            if(cmc != CURLM_OK) error ("curl_multi_perform() failed: " * curl_multi_strerror(cmc)) end

            now  = int64(time()*1000)
        end    

        if (n_active[1] == 0)
            msgs_in_queue = Array(Int32,1)
            p_msg::Ptr{CURLMsg2} = curl_multi_info_read(curlm, msgs_in_queue)

            while (p_msg != C_NULL)
#                println("Messages left in Q : " * string(msgs_in_queue[1]))
                msg = unsafe_ref(p_msg)

                if (msg.msg == CURLMSG_DONE)
                    if (convert(Int, msg.data) != CURLE_OK)
#                        println("Result of transfer: " * string(msg.data))
                        throw("Error executing request")
                    else
                        process_response(ctxt)
                    end
                end
                
                p_msg = curl_multi_info_read(curlm, msgs_in_queue)
            end
        else
            error ("request timed out")
        end

    finally
        curl_multi_remove_handle(curlm, curl)
        curl_multi_cleanup(curlm)
    end
    
    ctxt.resp    
end





end