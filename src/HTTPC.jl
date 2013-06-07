module HTTPC

using libCURL
using libCURL.Mime_ext

export init, cleanup, get, put, put_file, post, post_file, trace, delete, head, options


export RequestOptions, Response

import Base.convert


def_rto = 0.0


##############################
# Struct definitions
##############################

type RequestOptions
    blocking::Bool 
    query_params::Vector{Tuple} 
    request_timeout::Float64
    callback::Union(Function,Bool)
    content_type::String
    headers::Vector{Tuple}
    ostream::Union(IO, String, Nothing)
    auto_content_type::Bool
    
    RequestOptions(; blocking=true, query_params=Array(Tuple,0), request_timeout=def_rto, callback=null_cb, content_type="", headers=Array(Tuple,0), ostream=nothing, auto_content_type=true) = 
    new(blocking, query_params, request_timeout, callback, content_type, headers, ostream, auto_content_type)
end

type Response
    body
    headers
    http_code
    total_time
    
    Response() = new("", Dict{ASCIIString, ASCIIString}(), 0, 0.0)
    Response(ostr::IO) = new("", Dict{ASCIIString, ASCIIString}(), 0, 0.0)
end


type ReadData
    typ::Symbol
    src::Any
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
    options::RequestOptions
    ostream::Union(IO, Nothing)
    close_ostream::Bool
    
    ConnContext(options::RequestOptions) = new(C_NULL, "", C_NULL, ReadData(), Response(), options, nothing, false)
end

immutable CURLMsg2
  msg::CURLMSG
  easy_handle::Ptr{CURL}
  data::Ptr{Any}
end


##############################
# Callbacks
##############################

function write_cb(buff::Ptr{Uint8}, sz::Csize_t, n::Csize_t, p_ctxt::Ptr{Void})
#    println("@write_cb")
    ctxt = unsafe_pointer_to_objref(p_ctxt)
    if isa(ctxt.ostream, IO)
        write(ctxt.ostream, buff, sz * n)
    else
        ctxt.resp.body = ctxt.resp.body * bytestring(buff, convert(Int, sz * n))
    end
    (sz*n)::Csize_t
end

c_write_cb = cfunction(write_cb, Csize_t, (Ptr{Uint8}, Csize_t, Csize_t, Ptr{Void}))

function header_cb(buff::Ptr{Uint8}, sz::Csize_t, n::Csize_t, p_ctxt::Ptr{Void})
#    println("@header_cb")
    ctxt = unsafe_pointer_to_objref(p_ctxt)
    hdrlines = split(bytestring(buff, convert(Int, sz * n)), "\r\n")

#    println(hdrlines)
    for e in hdrlines
        m = match(r"^\s*([\w\-\_]+)\s*\:(.+)", e)
        if (m != nothing) 
            ctxt.resp.headers[strip(m.captures[1])] = strip(m.captures[2])
        end
    end
    (sz*n)::Csize_t
end

c_header_cb = cfunction(header_cb, Csize_t, (Ptr{Uint8}, Csize_t, Csize_t, Ptr{Void}))


function curl_read_cb(out::Ptr{Void}, s::Csize_t, n::Csize_t, p_ctxt::Ptr{Void})
#    println("@curl_read_cb")

    ctxt = unsafe_pointer_to_objref(p_ctxt)
    bavail = s * n
    breq = ctxt.rd.sz - ctxt.rd.offset
    b2copy = bavail > breq ? breq : bavail

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

null_cb(curl) = return nothing

function set_opt_blocking(options::RequestOptions)
        o2 = deepcopy(options)
        o2.blocking = true
        return o2
end

function get_ct_from_ext(filename)
    fparts = split(basename(filename), ".")
    if (length(fparts) > 1)
        if haskey(MimeExt, fparts[end]) return MimeExt[fparts[end]] end
    end
    return false
end


function setup_easy_handle(url, options::RequestOptions)
    ctxt = ConnContext(options)
    
    curl = curl_easy_init()
    if (curl == C_NULL) throw("curl_easy_init() failed") end

    ctxt.curl = curl

    @ce_curl curl_easy_setopt CURLOPT_FOLLOWLOCATION 1

    @ce_curl curl_easy_setopt CURLOPT_MAXREDIRS 5

    if length(options.query_params) > 0
        qp = urlencode_query_params(curl, options.query_params) 
        url = url * "?" * qp
    end


    ctxt.url = url
    
    @ce_curl curl_easy_setopt CURLOPT_URL url
    @ce_curl curl_easy_setopt CURLOPT_WRITEFUNCTION c_write_cb

    p_ctxt = pointer_from_objref(ctxt)

    @ce_curl curl_easy_setopt CURLOPT_WRITEDATA p_ctxt

    @ce_curl curl_easy_setopt CURLOPT_HEADERFUNCTION c_header_cb
    @ce_curl curl_easy_setopt CURLOPT_HEADERDATA p_ctxt

    if options.content_type != ""
        ct = "Content-Type: " * options.content_type
        ctxt.slist = curl_slist_append (ctxt.slist, ct)
    else
        # Disable libCURL automatically setting the content type
        ctxt.slist = curl_slist_append (ctxt.slist, "Content-Type:")
    end
    
    
    for hdr in options.headers
        hdr_str = hdr[1] * ":" * hdr[2]
        ctxt.slist = curl_slist_append (ctxt.slist, hdr_str)
    end

    # Disabling the Expect header since some webservers don't handle this properly
    ctxt.slist = curl_slist_append (ctxt.slist, "Expect:")
    @ce_curl curl_easy_setopt CURLOPT_HTTPHEADER ctxt.slist
    
    if isa(options.ostream, String)
        ctxt.ostream = open(options.ostream, "w+")
        ctxt.close_ostream = true
    elseif isa(options.ostream, IO)
        ctxt.ostream = options.ostream
    end
    
    ctxt
end

function cleanup_easy_context(ctxt::Union(ConnContext,Bool))
    if isa(ctxt, ConnContext)
        if (ctxt.slist != C_NULL)
            curl_slist_free_all(ctxt.slist)
        end

        if (ctxt.curl != C_NULL)
            curl_easy_cleanup(ctxt.curl)
        end
        
        if ctxt.close_ostream
            close(ctxt.ostream)
            ctxt.ostream = nothing
            ctxt.close_ostream = false
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

function get(url::String, options::RequestOptions=RequestOptions()) 
    if (options.blocking)
        ctxt = false
        try
            ctxt = setup_easy_handle(url, options)
            
            @ce_curl curl_easy_setopt CURLOPT_HTTPGET 1
            
            return exec_as_multi(ctxt)
        finally
            cleanup_easy_context(ctxt)
        end
    else
        return remotecall(myid(), get, url, set_opt_blocking(options))
    end
end



##############################
# POST & PUT
##############################

function post (url::String, data, options::RequestOptions=RequestOptions())
    if (options.blocking)
        return put_post(url, data, :post, options)
    else
        return remotecall(myid(), post, url, data, set_opt_blocking(options))
    end
end

function put (url::String, data, options::RequestOptions=RequestOptions()) 
    if (options.blocking)
        return put_post(url, data, :put, options)
    else
        return remotecall(myid(), put, url, data, set_opt_blocking(options))
    end
end



function put_post(url::String, data, putorpost::Symbol, options::RequestOptions)
    rd::ReadData = ReadData()
    
    if isa(data, String)
        rd.typ = :buffer
        rd.src = false
        rd.str = data
        rd.sz = length(data)
        
    elseif isa(data, Dict) || isa(data, Vector{Tuple})
        arr_data = isa(data, Dict) ? collect(data) : data
        rd.str = urlencode_query_params(arr_data)  # Not very optimal since it creates another curl handle, but it is clean...
        rd.sz = length(rd.str)
        rd.typ = :buffer
        rd.src = arr_data
        if ((options.content_type == "") && (options.auto_content_type))
            options.content_type = "application/x-www-form-urlencoded" 
        end
        
    elseif isa(data, IOStream)
        rd.typ = :io
        rd.src = data
        seekend(data)    
        rd.sz = position(data)
        seekstart(data)
        if ((options.content_type == "") && (options.auto_content_type))
            options.content_type = "application/octet-stream" 
        end
        
    elseif isa(data, Tuple)
        (typsym, filename) = data
        if (typsym != :file) error ("Unsupported data datatype") end

        rd.typ = :io
        rd.src = open(filename)
        rd.sz = filesize(filename)

        try
            if ((options.content_type == "") && (options.auto_content_type))
                options.content_type = get_ct_from_ext(filename) 
            end
            return _put_post(url, putorpost, options, rd)
        finally
            close(rd.src)
        end
    
    else 
        error ("Unsupported data datatype")
    end

    return _put_post(url, putorpost, options, rd)
end




function _put_post(url::String, putorpost::Symbol, options::RequestOptions, rd::ReadData)
    ctxt = false
    try
        ctxt = setup_easy_handle(url, options)
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

        return exec_as_multi(ctxt)
    finally
        cleanup_easy_context(ctxt)
    end
end



##############################
# HEAD, DELETE and TRACE
##############################
function head(url::String, options::RequestOptions=RequestOptions()) 
    if (options.blocking)
        ctxt = false
        try
            ctxt = setup_easy_handle(url, options)

            @ce_curl curl_easy_setopt CURLOPT_NOBODY 1

            return exec_as_multi(ctxt)
        finally
            cleanup_easy_context(ctxt)
        end
    else
        return remotecall(myid(), head, url, set_opt_blocking(options))
    end

end

delete(url::String, options::RequestOptions=RequestOptions()) = custom(url, "DELETE", options)
trace(url::String, options::RequestOptions=RequestOptions()) = custom(url, "TRACE", options)
options(url::String, options::RequestOptions=RequestOptions()) = custom(url, "OPTIONS", options) 

function custom(url::String, verb::String, options::RequestOptions)
    if (options.blocking)
        ctxt = false
        try
            ctxt = setup_easy_handle(url, options)

            @ce_curl curl_easy_setopt CURLOPT_CUSTOMREQUEST verb

            return exec_as_multi(ctxt)
        finally
            cleanup_easy_context(ctxt)
        end
    else
        return remotecall(myid(), custom, url, verb, set_opt_blocking(options))
    end
end


##############################
# EXPORTED UTILS
##############################

function urlencode_query_params(params::Vector{Tuple})
    curl = curl_easy_init()
    if (curl == C_NULL) throw("curl_easy_init() failed") end
    
    querystr = urlencode_query_params(curl, params)    

    curl_easy_cleanup(curl)
    
    return querystr
end
export urlencode_query_params

function urlencode_query_params(curl, params::Vector{Tuple})
    querystr = 
    mapreduce(
            i -> begin
                    k,v = i;
                    
                    if (v != "") 
                        ep = urlencode(curl, string(k)) * "=" * urlencode(curl, string(v))
                    else
                        ep = urlencode(curl, string(k)) 
                    end
                    
                    ep
                end,
                
            (ep1,ep2) -> ep1 == "" ? ep2 :
                       ep2 == "" ? ep1 :
                       ep1 * "&" * ep2,
            
            "", params
    )
    
    return querystr
end


function urlencode(curl, s::String)
    b_arr = curl_easy_escape(curl, s, length(s))
    esc_s = bytestring(b_arr)
    curl_free(b_arr)
    return esc_s
end

function urlencode(s::String)
    curl = curl_easy_init()
    if (curl == C_NULL) throw("curl_easy_init() failed") end

    esc_s = urlencode(curl, s)
    curl_easy_cleanup(curl)
    return esc_s
    
end
export urlencode



function exec_as_multi(ctxt)
    curl = ctxt.curl
    curlm = curl_multi_init()
    
    if (curlm == C_NULL) error("Unable to initialize curl_multi_init()") end

    try
        if isa(ctxt.options.callback, Function) ctxt.options.callback(curl) end
    
        cmc = curl_multi_add_handle(curlm, curl)
        if(cmc != CURLM_OK) error ("curl_multi_add_handle() failed: " * bytestring(curl_multi_strerror(cmc))) end

        n_active = Array(Int,1)
        n_active[1] = 1
        now  = int64(time()*1000)
        
        timeout_to_use = (ctxt.options.request_timeout) == 0.0 ? (30 * 24 * 3600.0) : ctxt.options.request_timeout
        till = now + int64(timeout_to_use * 1000) + 1
        
        cmc = curl_multi_perform(curlm, n_active);
        while (n_active[1] > 0) && ((till - now) > 0)
            sleep(0.025)   # 25 milliseconds
#            println("@sleep for url: " * ctxt.url)
            
            cmc = curl_multi_perform(curlm, n_active);    
            if(cmc != CURLM_OK) error ("curl_multi_perform() failed: " * bytestring(curl_multi_strerror(cmc))) end

            now  = int64(time()*1000)
        end    

        if (n_active[1] == 0)
            msgs_in_queue = Array(Cint,1)
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