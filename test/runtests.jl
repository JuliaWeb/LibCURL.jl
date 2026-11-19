using Test
using LibCURL
using Downloads: download

const XFERINFO_CALLS = Ref(0)

function xferinfo_continue(clientp::Ptr{Cvoid}, dltotal::curl_off_t, dlnow::curl_off_t,
                           ultotal::curl_off_t, ulnow::curl_off_t)::Cint
    XFERINFO_CALLS[] += 1
    return CURL_PROGRESSFUNC_CONTINUE
end

discard_write(ptr::Ptr{Cchar}, size::Csize_t, n::Csize_t, userdata::Ptr{Cvoid})::Csize_t = size * n

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

    @testset "xferinfo callback returning CURL_PROGRESSFUNC_CONTINUE" begin
        path = joinpath(mktempdir(), "data.txt")
        write(path, "hello")
        curl = curl_easy_init()
        curl == C_NULL && error("curl_easy_init() failed")
        write_cb = @cfunction(discard_write, Csize_t, (Ptr{Cchar}, Csize_t, Csize_t, Ptr{Cvoid}))
        xferinfo = @cfunction(xferinfo_continue, Cint,
                              (Ptr{Cvoid}, curl_off_t, curl_off_t, curl_off_t, curl_off_t))
        XFERINFO_CALLS[] = 0
        url = Sys.iswindows() ? "file:///" * replace(path, '\\' => '/') : "file://" * path
        curl_easy_setopt(curl, CURLOPT_URL, url)
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_cb)
        curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 0)
        curl_easy_setopt(curl, CURLOPT_XFERINFOFUNCTION, xferinfo)
        @test curl_easy_perform(curl) == CURLE_OK
        @test XFERINFO_CALLS[] > 0
        curl_easy_cleanup(curl)
    end

    include("ssl.jl")
end
