module httpc

using libCURL

#export init, cleanup, get

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



function cc_check(f, cc)
    if(cc != CURLE_OK)
      error (string(f) * "() failed: " * curl_easy_strerror(cc))
    end
end



function get(url)
    curl = curl_easy_init();
    cc_check (:curl_easy_setopt,  curl_easy_setopt(curl,CURLOPT_FOLLOWLOCATION,1))
    
    cc_check (:curl_easy_setopt,  curl_easy_setopt(curl, CURLOPT_URL, url))
    cc_check (:curl_easy_setopt,  curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, c_write_cb))
    
    response = Response("", Dict{ASCIIString, ASCIIString}(), 0, 0.0)
    uctxt = pointer_from_objref(response)
    
    cc_check (:curl_easy_setopt,  curl_easy_setopt(curl, CURLOPT_WRITEDATA, uctxt))

    cc_check (:curl_easy_setopt,  curl_easy_setopt(curl, CURLOPT_HEADERFUNCTION, c_header_cb))
    cc_check (:curl_easy_setopt,  curl_easy_setopt(curl, CURLOPT_HEADERDATA, uctxt))
    
    cc_check (:curl_easy_perform,  curl_easy_perform(curl))
    
    http_code = Array(Int,1)
    cc_check (:curl_easy_getinfo,  curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, http_code))
    
    total_time = Array(Float64,1)
    cc_check (:curl_easy_getinfot,  curl_easy_getinfo(curl, CURLINFO_TOTAL_TIME, total_time))

    response.http_code = http_code[1]
    response.total_time = total_time[1]
    
    curl_easy_cleanup(curl)
    
    response
end


end


