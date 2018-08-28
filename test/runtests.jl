using LibCURL
using Compat.Test

# Just testing loading of the library and a simple library call.
curl = curl_easy_init()
curl == C_NULL && error("curl_easy_init() failed")

@testset "test escape" begin
    function testescape(s, esc_s)
        b_arr = curl_easy_escape(curl, s, sizeof(s))
        unsafe_string(b_arr) != esc_s && error("escaping $s failed")
        curl_free(b_arr)
    end

    testescape("hello world", "hello%20world")
    testescape("hello %world", "hello%20%25world")
    testescape("hello%world", "hello%25world")
end

@testset "download" begin
    url = "https://github.com/JuliaWeb/LibCURL.jl/blob/master/README.md"
    filename = joinpath(@__DIR__, "README.md")

    @testset "julia download" begin
        try
            download(url, filename)
            @test isfile(filename)
        finally
            rm(filename; force=true)
        end
    end

    @testset "system curl" begin
        try
            run(`curl -g -L -f -o $filename $url`)
            @test isfile(filename)
        finally
            rm(filename; force=true)
        end
    end
end

curl_easy_cleanup(curl)
