# Test that https://www.google.com successfully connects
curl = curl_easy_init()
curl == C_NULL && error("curl_easy_init() failed")

@testset "SSL: https://www.google.com" begin
    curl_easy_setopt(curl, CURLOPT_URL, "https://www.google.com")
    curl_easy_setopt(curl, CURLOPT_USE_SSL, CURLUSESSL_ALL)
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 2)
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 1)

    res = curl_easy_perform(curl)
    @test res == CURLE_OK
end

curl_easy_cleanup(curl)
