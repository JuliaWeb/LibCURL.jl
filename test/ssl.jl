# Test that https://www.google.com successfully connects
curl = curl_easy_init()
curl == C_NULL && error("curl_easy_init() failed")

# Setup the callback function to recv data
function curl_write_cb(curlbuf::Ptr{Cvoid}, s::Csize_t, n::Csize_t, p_ctxt::Ptr{Cvoid})
    sz = s * n
    data = Array{UInt8}(undef, sz)

    ccall(:memcpy, Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, UInt64), data, curlbuf, sz)

    sz::Csize_t
end

@testset "SSL: https://www.google.com" begin
    c_curl_write_cb = @cfunction(
        curl_write_cb,
        Csize_t,
        (Ptr{Cvoid}, Csize_t, Csize_t, Ptr{Cvoid})
    )
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, c_curl_write_cb)

    curl_easy_setopt(curl, CURLOPT_URL, "https://www.google.com")
    curl_easy_setopt(curl, CURLOPT_USE_SSL, CURLUSESSL_ALL)
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 2)
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 1)

    @testset "Failure: no cacert" begin
        res = curl_easy_perform(curl)
        @test res != CURLE_OK
    end

    @testset "Success: find_system_cert" begin
        cacert = find_system_cacert()
        enable_cacert(curl, cacert)
        res = curl_easy_perform(curl)
        @test res == CURLE_OK
    end
end

curl_easy_cleanup(curl)
