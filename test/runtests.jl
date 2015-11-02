using LibCURL

# Just testing loading of the library and a simple library call.
curl = curl_easy_init()
curl == C_NULL && error("curl_easy_init() failed")

function testescape(s, esc_s)
    b_arr = curl_easy_escape(curl, s, sizeof(s))
    bytestring(b_arr) != esc_s && error("escaping $s failed")
    curl_free(b_arr)
end

testescape("hello world", "hello%20world")
testescape("hello %world", "hello%20%25world")
testescape("hello%world", "hello%25world")

curl_easy_cleanup(curl)
