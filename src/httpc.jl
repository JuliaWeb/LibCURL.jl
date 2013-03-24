module httpc

using libCURL

export init, cleanup, get, Response

init() = curl_global_init(CURL_GLOBAL_ALL)
cleanup() = curl_global_cleanup()

type Response
    body
    headers
    http_code
    total_time
end



function write_cb(buff::Ptr{Uint8}, sz::Uint32, n::Uint32, uctxt::Ptr{Void})
    r = unsafe_pointer_to_objref(uctxt)
    r.body = r.body * bytestring(buff, convert(Int32, sz * n))
    sz*n
end

c_write_cb = cfunction(write_cb, Uint32, (Ptr{Uint8}, Uint32, Uint32, Ptr{Void}))

function header_cb(buff::Ptr{Uint8}, sz::Uint32, n::Uint32, uctxt::Ptr{Void})
    r = unsafe_pointer_to_objref(uctxt)
    hdrlines = split(bytestring(buff, convert(Int32, sz * n)), "\r\n")
    
    for e in hdrlines
        m = match(r"^\s*([\w\-\_]+)\s*\:(.+)", e)
        if (m != nothing) 
            r.headers[strip(m.captures[1])] = strip(m.captures[2])
        end
    end
    sz*n
end

c_header_cb = cfunction(header_cb, Uint32, (Ptr{Uint8}, Uint32, Uint32, Ptr{Void}))



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
            error (string($f) * "() failed: " * curl_easy_strerror(cc))
        end
    end    
end


# function cc_check(f, cc)
#     if(cc != CURLE_OK)
#       error (string(f) * "() failed: " * curl_easy_strerror(cc))
#     end
# end

function setup_easy_get(url)
    curl = curl_easy_init()

    @ce_curl curl_easy_setopt CURLOPT_FOLLOWLOCATION 1
        
    @ce_curl curl_easy_setopt CURLOPT_URL url
    @ce_curl curl_easy_setopt CURLOPT_WRITEFUNCTION c_write_cb
    
    response = Response("", Dict{ASCIIString, ASCIIString}(), 0, 0.0)
    uctxt = pointer_from_objref(response)
    
    @ce_curl curl_easy_setopt CURLOPT_WRITEDATA uctxt

    @ce_curl curl_easy_setopt CURLOPT_HEADERFUNCTION c_header_cb
    @ce_curl curl_easy_setopt CURLOPT_HEADERDATA uctxt
    
    (curl, response)
        
end

function process_response(curl, response)
    http_code = Array(Int,1)
    @ce_curl curl_easy_getinfo CURLINFO_RESPONSE_CODE http_code
    
    total_time = Array(Float64,1)
    @ce_curl curl_easy_getinfo CURLINFO_TOTAL_TIME total_time

    response.http_code = http_code[1]
    response.total_time = total_time[1]
    
end

function get_s (url)                # Synchronous version of GET. Should never be used.... Remove it?
    (curl, response) = setup_easy_get(url)

    @ce_curl curl_easy_perform 
    
    process_response(curl, response)
    
    curl_easy_cleanup(curl)
    
    response
end


# function curl_socket_cb(curl::Ptr{Void}, s::Cint, action::Cint, uctxt::Ptr{Void}, sctxt::Ptr{Void})
# 
#     return 0
# end
# 
# c_curl_socket_cb = cfunction(curl_socket_cb, Cint, (Ptr{Void}, Cint, Cint, Ptr{Void}, Ptr{Void}))
# 
# 
# function curl_multi_timer_cb(curlm::Ptr{Void}, timeout_ms::Clong, uctxt::Ptr{Void})
# 
#     return 0
# end
# 
# c_curl_multi_timer_cb = cfunction(curl_multi_timer_cb, Cint, (Ptr{Void}, Clong, Ptr{Void}))


function get(url)
    get(url, 10)
end

function get(url, timeout)
    curlm = curl_multi_init()
    curl = 0
    response = nothing
    
    if (curlm == 0) error("Unable to initialize curl_multi_init()") end

    try
        (curl, response) = setup_easy_get(url)

        cmc = curl_multi_add_handle(curlm, curl)
        if(cmc != CURLM_OK) error ("curl_multi_add_handle() failed: " * curl_multi_strerror(cmc)) end

    #     cmc = curl_multi_setopt(curlm, CURLMOPT_SOCKETFUNCTION, c_curl_socket_cb)    
    #     if(cmc != CURLM_OK) error ("curl_multi_setopt() failed: " * curl_multi_strerror(cmc)) end
    # 
    #     cmc = curl_multi_setopt(curlm, CURLMOPT_TIMERFUNCTION, c_curl_multi_timer_cb)    
    #     if(cmc != CURLM_OK) error ("curl_multi_setopt() failed: " * curl_multi_strerror(cmc)) end
    # 
    #     # start the multi session
    #     n_active = Array(Int,1)
    #     curl_multi_socket_action(curlm, CURL_SOCKET_TIMEOUT, 0, n_active)     

        n_active = Array(Int,1)
        n_active[1] = 1
        now  = int(time())
        till = now + timeout
        while (n_active[1] > 0) && ((till - now) > 0)
            cmc = curl_multi_perform(curlm, n_active);    
            if(cmc != CURLM_OK) error ("curl_multi_perform() failed: " * curl_multi_strerror(cmc)) end
            
            sleep(0.01)   # 10 milliseconds
            now  = int(time())
        end    

        if (n_active[1] == 0)
            process_response(curl, response)
            curlm_cleanup(curlm, curl)
        else
            error ("request timed out")
        end

    catch e
        if (curl != 0)
            curl_multi_remove_handle(curlm, curl)
            curl_easy_cleanup(curl)
        end
        
        curl_multi_cleanup(curlm)
        throw (string(e))
    end
    
    response    
end

function curlm_cleanup(curlm, curl)
    curl_multi_remove_handle(curlm, curl)
    curl_easy_cleanup(curl)
    curl_multi_cleanup(curlm)
end

end