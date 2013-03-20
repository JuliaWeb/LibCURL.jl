module httpc

using libCURL

export init, cleanup

init() = curl_global_init(CURL_GLOBAL_ALL)
cleanup() = curl_global_cleanup()



function get(url)
    curl = curl_easy_init();
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1);
    curl_easy_setopt(curl, CURLOPT_URL, url);
    res = curl_easy_perform(curl);
    if(res != CURLE_OK)
      @printf "curl_easy_perform() failed: %s\n" curl_easy_strerror(res)
    end
    
    curl_easy_cleanup(curl);
end


end


