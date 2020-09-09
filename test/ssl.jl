# Test that https://www.google.com successfully connects
curl = curl_easy_init()
curl == C_NULL && error("curl_easy_init() failed")

# Setup the callback function to recv data
function curl_write_cb(curlbuf::Ptr{Cvoid}, s::Csize_t, n::Csize_t, p_ctxt::Ptr{Cvoid})
    sz = s * n
    data = Array{UInt8}(undef, sz)
    ccall(:memcpy, Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, Csize_t), data, curlbuf, sz)
    return sz::Csize_t
end

@testset "SSL verify" begin
    # Set up the write function to consume the curl output so we don't see it in the
    # test output
    c_curl_write_cb = @cfunction(
        curl_write_cb,
        Csize_t,
        (Ptr{Cvoid}, Csize_t, Csize_t, Ptr{Cvoid})
    )
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, c_curl_write_cb)

    # Set up our SSL options
    curl_easy_setopt(curl, CURLOPT_URL, "https://www.google.com")
    curl_easy_setopt(curl, CURLOPT_USE_SSL, CURLUSESSL_ALL)
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 2)
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 1)
    curl_easy_setopt(curl, CURLOPT_CAINFO, LibCURL.cacert)

    @testset "SSL Success" begin
        res = curl_easy_perform(curl)
        @test res == CURLE_OK
    end

end

curl_easy_cleanup(curl)
