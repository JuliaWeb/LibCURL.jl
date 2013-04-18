module httpc

using libCURL
using mime_ext

export init, cleanup, get, upload, upload_file, post, post_file
export Response, ContentType

import Base.convert

typealias Callback Union(Function,Bool)
typealias ContentType Union(String,Bool)

timeout_default = 30.0

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
    fd::IOStream
    str::String
    offset::Int
    sz::Int

    ReadData() = new()
end

type ConnContext
    slist::Ptr{Void}
    rd::ReadData
    resp::Response
    
    ConnContext() = new(0, ReadData(), Response())
end

##############################
# Callbacks
##############################

function write_cb(buff::Ptr{Uint8}, sz::Uint32, n::Uint32, p_ctxt::Ptr{Void})
    println("@write_cb")
    ctxt = unsafe_pointer_to_objref(p_ctxt)
    ctxt.resp.body = ctxt.resp.body * bytestring(buff, convert(Int32, sz * n))
    sz*n
end

c_write_cb = cfunction(write_cb, Uint32, (Ptr{Uint8}, Uint32, Uint32, Ptr{Void}))

function header_cb(buff::Ptr{Uint8}, sz::Uint32, n::Uint32, p_ctxt::Ptr{Void})
    println("@header_cb")
    uctxt = unsafe_pointer_to_objref(p_ctxt)
    hdrlines = split(bytestring(buff, convert(Int32, sz * n)), "\r\n")
    
    for e in hdrlines
        m = match(r"^\s*([\w\-\_]+)\s*\:(.+)", e)
        if (m != nothing) 
            uctxt.resp.headers[strip(m.captures[1])] = strip(m.captures[2])
        end
    end
    sz*n
end

c_header_cb = cfunction(header_cb, Uint32, (Ptr{Uint8}, Uint32, Uint32, Ptr{Void}))




function curl_read_cb(out::Ptr{Void}, s::Csize_t, n::Csize_t, p_ctxt::Ptr{Void})
#    println("@curl_read_cb")

    ctxt = unsafe_pointer_to_objref(p_ctxt)
    b2copy = s * n

    if (b2copy > (ctxt.rd.sz - ctxt.rd.offset))
        return convert(Csize_t, CURL_READFUNC_ABORT)
    end

    if (ctxt.rd.typ == :buffer)
        ccall(:memcpy, Ptr{Void}, (Ptr{Void}, Ptr{Void}, Uint),
                out, convert(Ptr{Uint8}, ctxt.rd.str) + ctxt.rd.offset, b2copy)
    elseif (ctxt.rd.typ == :io)
        b_read = read(ctxt.rd.fd, Uint8, b2copy)
        ccall(:memcpy, Ptr{Void}, (Ptr{Void}, Ptr{Void}, Uint), out, b_read, b2copy)
    end

    return convert(Csize_t, 0)
end

c_curl_read_cb = cfunction(curl_read_cb, Csize_t, (Ptr{Void}, Csize_t, Csize_t, Ptr{Void}))


##############################
# Utility functions
##############################

macro ce_curl (f, args...)
    quote
        cc = CURLE_OK
        try
            cc = $(esc(f))(curl, $(args...)) 
        catch 
            curl_easy_cleanup(curl)
            error("curl error")
        end
        
        if(cc != CURLE_OK)
            curl_easy_cleanup(curl)
            error (string($f) * "() failed: " * bytestring(curl_easy_strerror(cc)))
        end
    end    
end


function setup_easy_get(url)
    curl = curl_easy_init()

    @ce_curl curl_easy_setopt CURLOPT_FOLLOWLOCATION 1

    @ce_curl curl_easy_setopt CURLOPT_MAXREDIRS 5
        
    @ce_curl curl_easy_setopt CURLOPT_URL url
    @ce_curl curl_easy_setopt CURLOPT_WRITEFUNCTION c_write_cb
    
    uctxt = ConnContext()
    p_uctxt = pointer_from_objref(uctxt)
    
    @ce_curl curl_easy_setopt CURLOPT_WRITEDATA p_uctxt

    @ce_curl curl_easy_setopt CURLOPT_HEADERFUNCTION c_header_cb
    @ce_curl curl_easy_setopt CURLOPT_HEADERDATA p_uctxt
    
    (curl, uctxt)
        
end

function process_response(curl, resp)
    http_code = Array(Int,1)
    @ce_curl curl_easy_getinfo CURLINFO_RESPONSE_CODE http_code
    
    total_time = Array(Float64,1)
    @ce_curl curl_easy_getinfo CURLINFO_TOTAL_TIME total_time

    resp.http_code = http_code[1]
    resp.total_time = total_time[1]
    
end

function blocking_get (url)
    (curl, uctxt) = setup_easy_get(url)

    @ce_curl curl_easy_perform 
    
    process_response(curl, uctxt.resp)
    
    curl_easy_cleanup(curl)
    
    ctxt.resp
end





##############################
# Library initializations
##############################

init() = curl_global_init(CURL_GLOBAL_ALL)
cleanup() = curl_global_cleanup()


##############################
# GET
##############################

function get(url::String; timeout=timeout_default, cb=false)
    (curl, uctxt) = setup_easy_get(url)
    exec_as_multi(curl, uctxt, timeout, cb)
end


##############################
# POST
##############################

function post (url::String, data::String; content_type=false, timeout=timeout_default, cb=false)
    rd::ReadData = ReadData()
    rd.typ = :buffer
    rd.offset = 0
    rd.sz = length(data)
    rd.str = data

    _post(url, content_type, timeout, cb, rd)

end


function post_file (url::String, filename::String; content_type=false, timeout=timeout_default, cb=false)
    rd::ReadData = ReadData()
    rd.typ = :io
    rd.offset = 0
    rd.fd = open(filename)
    rd.sz = filesize(filename)

    local response
    try
        response = _post(url, content_type, timeout, cb, rd)
    finally
        close(rd.fd)
    end
    
    response
end




function _post(url::String, content_type::ContentType, timeout::Float64, cb::Callback, rd::ReadData)
    (curl, ctxt) = setup_easy_get(url)

    @ce_curl curl_easy_setopt CURLOPT_POST 1

    @ce_curl curl_easy_setopt CURLOPT_POSTFIELDSIZE rd.sz
    
    if (rd.typ == :io)
        p_ctxt = pointer_from_objref(ctxt)
        @ce_curl curl_easy_setopt CURLOPT_READDATA p_ctxt

        @ce_curl curl_easy_setopt CURLOPT_READFUNCTION c_curl_read_cb
    else
        println("@1")
        ppostdata = pointer(convert(Array{Uint8}, rd.str), 1)
        println(ppostdata)
        @ce_curl curl_easy_setopt CURLOPT_COPYPOSTFIELDS ppostdata
        println("@2")
    end
    

    if isa(content_type, String)
        ct = "Content-Type: " * content_type
        ctxt.slist = curl_slist_append (ctxt.slist, ct)
        @ce_curl curl_easy_setopt CURLOPT_HTTPHEADER ctxt.slist
    end

    local response
    try
        response = exec_as_multi(curl, ctxt, timeout, cb)
    finally
        if isa(content_type, String) && (ctxt.slist != 0)
            curl_slist_free_all(ctxt.slist)
        end
    end

    response
end

##############################
# PUT
##############################

function upload_file(url::String, filename::String; timeout=timeout_default, cb=false)
    rd::ReadData = ReadData()
    rd.typ = :io
    rd.offset = 0
    rd.fd = open(filename)
    rd.sz = filesize(filename)

    local response
    try
        response = _upload(url, timeout, rd, cb)
    finally
        close(rd.fd)
    end

    response
end
    

function upload(url::String, data::String, timeout=timeout_default, cb=false)
    rd::ReadData = ReadData()
    rd.typ = :buffer
    rd.str = data
    rd.offset = 0
    rd.sz = length(data)
    
    _upload(url, timeout, rd, cb)
end

function _upload(url::String, timeout::Float64, rd::ReadData, cb::Callback)
    (curl, ctxt) = setup_easy_get(url)
    ctxt.rd = rd
    
    @ce_curl curl_easy_setopt CURLOPT_INFILESIZE rd.sz

    p_ctxt = pointer_from_objref(ctxt)
    @ce_curl curl_easy_setopt CURLOPT_READDATA p_ctxt

    @ce_curl curl_easy_setopt CURLOPT_READFUNCTION c_curl_read_cb
    

    @ce_curl curl_easy_setopt CURLOPT_UPLOAD 1

    exec_as_multi(curl, ctxt, timeout, cb)
end



function exec_as_multi(curl, ctxt, timeout::Float64, cb::Callback)
    curlm = curl_multi_init()
    
    if (curlm == 0) error("Unable to initialize curl_multi_init()") end

    try
        if isa(cb, Function) cb(curl) end
    
        cmc = curl_multi_add_handle(curlm, curl)
        if(cmc != CURLM_OK) error ("curl_multi_add_handle() failed: " * curl_multi_strerror(cmc)) end

        n_active = Array(Int,1)
        n_active[1] = 1
        now  = int64(time()*1000)
        till = now + int64(timeout * 1000) + 1
        
        cmc = curl_multi_perform(curlm, n_active);
        while (n_active[1] > 0) && ((till - now) > 0)
            sleep(0.025)   # 25 milliseconds
#            println("@sleep")
            
            cmc = curl_multi_perform(curlm, n_active);    
            if(cmc != CURLM_OK) error ("curl_multi_perform() failed: " * curl_multi_strerror(cmc)) end

            now  = int64(time()*1000)
        end    

        if (n_active[1] == 0)
            process_response(curl, ctxt.resp)
        else
            error ("request timed out")
        end

    finally
        if (curl != 0)
            curl_multi_remove_handle(curlm, curl)
            curl_easy_cleanup(curl)
        end
        
        curl_multi_cleanup(curlm)
    end
    
    ctxt.resp    
end

function curlm_cleanup(curlm, curl)
    curl_multi_remove_handle(curlm, curl)
    curl_easy_cleanup(curl)
    curl_multi_cleanup(curlm)
end



end