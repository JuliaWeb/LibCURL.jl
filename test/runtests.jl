using Test
using LibCURL
using Downloads: download

# Just testing loading of the library and a simple library call.

@testset "LibCURL" begin
    @testset "test escape" begin
        curl = curl_easy_init()
        curl == C_NULL && error("curl_easy_init() failed")

        function testescape(s, esc_s)
            b_arr = curl_easy_escape(curl, s, sizeof(s))
            us = unsafe_string(b_arr)
            us != esc_s && error("escaping $s failed")
            curl_free(b_arr)
            @test us == esc_s
        end

        testescape("hello world", "hello%20world")
        testescape("hello %world", "hello%20%25world")
        testescape("hello%world", "hello%25world")

        curl_easy_cleanup(curl)
    end

    @testset "download" begin
        curl = curl_easy_init()
        curl == C_NULL && error("curl_easy_init() failed")

        url = "https://github.com/JuliaWeb/LibCURL.jl/blob/master/README.md"
        filename = joinpath(mktempdir(), "README.md")

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
                run(`curl -s -S -g -L -f -o $filename $url`)
                @test isfile(filename)
            finally
                rm(filename; force=true)
            end
        end

        curl_easy_cleanup(curl)
    end

    include("ssl.jl")
end
