module HTTPC

using libCURL
using libCURL.Mime_ext

export init, cleanup, get, put, put_file, post, post_file, trace, delete, head, options
export get_nb, post_nb, put_nb, post_file_nb, put_file_nb, head_nb, delete_nb, trace_nb, options_nb


export Response, ContentType, QueryStrDict

import Base.convert

typealias Callback Union(Function,Bool)
typealias ContentType Union(String,Bool)
typealias QueryDict Union(Dict,Bool)

def_rto = 30.0

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
    src::Union(Dict, IOStream, Bool)
    str::String
    offset::Int
    sz::Int

    ReadData() = new(:undefined, false, "", 0, 0)
end

type ConnContext
    curl::Ptr{CURL}
    url::String
    slist::Ptr{Void}
    rd::ReadData
    resp::Response
    rto::Float64
    cb::Callback
    ct::ContentType
    
    ConnContext() = new(0, "", 0, ReadData(), Response(), def_rto, false, false)
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
        b_read = read(ctxt.rd.src, Uint8, b2copy)
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
        if haskey(MimeExt, fparts[end]) return MimeExt[fparts[end]] end
    end
    return false
end

function urlencode_dict(curl, qdict::Dict)
    #TODO put it in a try-finally block, to ensure no leaks...
    mapreduce(
            i -> begin
                    k,v = i;
                    sk = string(k)
                    sv = string(v)
                    
                    ek = curl_easy_escape( curl, sk, length(sk))
                    ev = curl_easy_escape( curl, sv, length(sv))

                    ep = bytestring(ek) * "=" * bytestring(ev)

                    curl_free(ek)
                    curl_free(ev)
                    
                    ep
                end,
                
            (ep1,ep2) -> ep1 * "&&" * ep2,
            
            collect(qdict)
    )
end

function setup_easy_handle(url, qd::QueryDict, rto::Float64, cb::Callback, ct::ContentType)
    ctxt = ConnContext()
    ctxt.rto = rto
    ctxt.cb = cb
    ctxt.ct = ct
    
    curl = curl_easy_init()
    if (curl == 0) throw("curl_easy_init() failed") end

    ctxt.curl = curl

    @ce_curl curl_easy_setopt CURLOPT_FOLLOWLOCATION 1

    @ce_curl curl_easy_setopt CURLOPT_MAXREDIRS 5

    if isa(qd, Dict)
        qp = urlencode_dict(curl, qd) 
        url = url * "?" * qp
    end


    ctxt.url = url
    
    @ce_curl curl_easy_setopt CURLOPT_URL url
    @ce_curl curl_easy_setopt CURLOPT_WRITEFUNCTION c_write_cb

    p_ctxt = pointer_from_objref(ctxt)

    @ce_curl curl_easy_setopt CURLOPT_WRITEDATA p_ctxt

    @ce_curl curl_easy_setopt CURLOPT_HEADERFUNCTION c_header_cb
    @ce_curl curl_easy_setopt CURLOPT_HEADERDATA p_ctxt

    if isa(ct, String)
        ct = "Content-Type: " * ct
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

function get(url::String; nb=false, qd=false, rto=def_rto, cb=false) 
    nb ? get_nb(url, qd=qd, rto=rto, cb=cb) : get_i(url, qd, rto, cb)
end

get_nb(url::String; qd=false, rto=def_rto, cb=false) = remotecall(myid(), get_i, url, qd, rto, cb)

function get_i(url::String, qd::QueryDict, rto::Float64, cb=Callback)
    ctxt = false
    try
        ctxt = setup_easy_handle(url, qd, rto, cb, false)
        
        @ce_curl curl_easy_setopt CURLOPT_HTTPGET 1
        
        return exec_as_multi(ctxt)
    finally
        cleanup_easy_context(ctxt)
    end
end


##############################
# POST & PUT
##############################

function post (url::String, data; nb=false, qd=false, ct=false, rto=def_rto, cb=false)
    nb ? post_nb (url, data, qd=qd, ct=ct, rto=rto, cb=cb) : put_post(url, qd, :post, data, ct, rto, cb)
end
post_nb (url::String, data; qd=false, ct=false, rto=def_rto, cb=false) =
    remotecall(myid(), put_post, url, qd, :post, data, ct, rto, cb)

function put (url::String, data; nb=false, qd=false, ct=false, rto=def_rto, cb=false) 
    nb ? put_nb (url, data, qd=qd, ct=ct, rto=rto, cb=cb) : put_post(url, qd, :put, data, ct, rto, cb)
end
put_nb (url::String, data; qd=false, ct=false, rto=def_rto, cb=false) = remotecall(myid(), put_post, url, qd, :put, data, ct, rto, cb)




function put_post(url::String, qd::QueryDict, putorpost::Symbol, data, ct::ContentType, rto::Float64, cb::Callback)
    rd::ReadData = ReadData()
    
    if isa(data, String)
        rd.typ = :buffer
        rd.src = false
        rd.str = data
        rd.sz = length(data)
        
    elseif isa(data, Dict)
        rd.typ = :dict
        rd.src = data
        if (ct == false) ct = "application/x-www-form-urlencoded" end
        
    elseif isa(data, IOStream)
        rd.typ = :io
        rd.src = data
        seekend(data)    
        rd.sz = position(data)
        seekstart(data)
        if (ct == false) ct = "application/octet-stream" end
        
    elseif isa(data, Tuple)
        (typsym, filename) = data
        if (typsym != :file) error ("Unsupported data datatype") end

        rd.typ = :io
        rd.src = open(filename)
        rd.sz = filesize(filename)

        try
            if (ct == false) ct = get_ct_from_ext(filename) end
            return _put_post(url, qd, putorpost, ct, rto, cb, rd)
        finally
            close(rd.src)
        end
    
    else 
        error ("Unsupported data datatype")
    end

    return _put_post(url, qd, putorpost, ct, rto, cb, rd)
end




function _put_post(url::String, qd::QueryDict, putorpost::Symbol, ct::ContentType, rto::Float64, cb::Callback, rd::ReadData)
    ctxt = false
    try
        ctxt = setup_easy_handle(url, qd, rto, cb, ct)
        ctxt.rd = rd

        if (rd.typ == :dict)
            rd.str = urlencode_dict(ctxt.curl, rd.src)
            rd.sz = length(rd.str)
            rd.typ = :buffer
        end
        
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
function head(url::String; nb=false, qd=false, rto=def_rto, cb=false) 
    nb ? head_nb(url, qd=qd, rto=rto, cb=cb) : head_i(url, qd, rto, cb)
end
head_nb(url::String; qd=false, rto=def_rto, cb=false) = remotecall(myid(), head_i, url, qd, rto, cb)

function head_i(url::String, qd::QueryDict, rto::Float64, cb::Callback)
    ctxt = false
    try
        ctxt = setup_easy_handle(url, qd, rto, cb, false)

        @ce_curl curl_easy_setopt CURLOPT_NOBODY 1

        return exec_as_multi(ctxt)
    finally
        cleanup_easy_context(ctxt)
    end
end

function delete(url::String; nb=false, qd=false, rto=def_rto, cb=false) 
    nb ? delete_nb(url, qd=qd, rto=rto, cb=cb) : custom(url, qd, "DELETE", rto, cb)
end
delete_nb(url::String; qd=false, rto=def_rto, cb=false) = remotecall(myid(), custom, url, qd, "DELETE", rto, cb)

function trace(url::String; nb=false, qd=false, rto=def_rto, cb=false)
    nb ? trace_nb(url, qd=qd, rto=rto, cb=cb) : custom(url, qd, "TRACE", rto, cb)
end
trace_nb(url::String; qd=false, rto=def_rto, cb=false) = remotecall(myid(), custom, url, qd, "TRACE", rto, cb)

function options(url::String; nb=false, qd=false, rto=def_rto, cb=false) 
    nb ? options_nb(url, qd=qd, rto=rto, cb=cb) : custom(url, qd, "OPTIONS", rto, cb)
end
options_nb(url::String; qd=false, rto=def_rto, cb=false) = remotecall(myid(), custom, url, qd, "OPTIONS", rto, cb)

function custom(url::String, qd::QueryDict, verb::String, rto::Float64, cb::Callback)
    ctxt = false
    try
        ctxt = setup_easy_handle(url, qd, rto, cb, false)

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
        if(cmc != CURLM_OK) error ("curl_multi_add_handle() failed: " * bytestring(curl_multi_strerror(cmc))) end

        n_active = Array(Int,1)
        n_active[1] = 1
        now  = int64(time()*1000)
        till = now + int64(ctxt.rto * 1000) + 1
        
        cmc = curl_multi_perform(curlm, n_active);
        while (n_active[1] > 0) && ((till - now) > 0)
            sleep(0.025)   # 25 milliseconds
#            println("@sleep for url: " * ctxt.url)
            
            cmc = curl_multi_perform(curlm, n_active);    
            if(cmc != CURLM_OK) error ("curl_multi_perform() failed: " * bytestring(curl_multi_strerror(cmc))) end

            now  = int64(time()*1000)
        end    

        if (n_active[1] == 0)
            msgs_in_queue = Array(Int32,1)
            p_msg::Ptr{CURLMsg2} = curl_multi_info_read(curlm, msgs_in_queue)

            while (p_msg != C_NULL)
#                println("Messages left in Q : " * string(msgs_in_queue[1]))
                msg = unsafe_load(p_msg)

                if (msg.msg == CURLMSG_DONE)
                    ec = convert(Int, msg.data) 
                    if (ec != CURLE_OK)
#                        println("Result of transfer: " * string(msg.data))
                        throw("Error executing request : " * bytestring(curl_easy_strerror(ec)))
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