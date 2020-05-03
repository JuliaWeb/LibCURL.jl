LibCURL.jl
==========

*Julia wrapper for libCURL*

[![Build Status](https://travis-ci.com/JuliaWeb/LibCURL.jl.svg?branch=master)](https://travis-ci.com/JuliaWeb/LibCURL.jl)
[![Cirrus](https://api.cirrus-ci.com/github/JuliaWeb/LibCURL.jl.svg)](https://cirrus-ci.com/github/JuliaWeb/LibCURL.jl)
[![Appveyor](https://ci.appveyor.com/api/projects/status/github/JuliaWeb/LibCurl.jl?svg=true)](https://ci.appveyor.com/project/shashi/libcurl-jl)
[![codecov.io](http://codecov.io/github/JuliaWeb/LibCURL.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaWeb/LibCURL.jl?branch=master)

---
This is a simple Julia wrapper around http://curl.haxx.se/libcurl/ generated using [Clang.jl](https://github.com/ihnorton/Clang.jl). Please see the [libcurl api documentation](https://curl.haxx.se/libcurl/c/) for help on how to use this package. 

### Example (fetch a URL)

```julia
using LibCURL

# init a curl handle
curl = curl_easy_init()

# set the URL and request to follow redirects
curl_easy_setopt(curl, CURLOPT_URL, "http://example.com")
curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)


# setup the callback function to recv data
function curl_write_cb(curlbuf::Ptr{Cvoid}, s::Csize_t, n::Csize_t, p_ctxt::Ptr{Cvoid})
    sz = s * n
    data = Array{UInt8}(undef, sz)

    ccall(:memcpy, Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, UInt64), data, curlbuf, sz)
    println("recd: ", String(data))

    sz::Csize_t
end

c_curl_write_cb = @cfunction(curl_write_cb, Csize_t, (Ptr{Cvoid}, Csize_t, Csize_t, Ptr{Cvoid}))
curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, c_curl_write_cb)


# execute the query
res = curl_easy_perform(curl)
println("curl url exec response : ", res)

# retrieve HTTP code
http_code = Array{Clong}(undef, 1)
curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, http_code)
println("httpcode : ", http_code)

# release handle
curl_easy_cleanup(curl)

```

### Binaries

This package uses the [LibCURL_jll](https://github.com/JuliaBinaryWrappers/libCURL_jll.jl) binary package to install compiled libCURL binaries on all supported platforms. The following products are defined in the jll

* `libcurl`: A `LibraryProduct` referencing the shared library
* `curl`: An `ExecutableProduct` referencing the binary
* `cacert`: A `FileProduct` referencing the Mozilla CA certificate bundle

### SSL certificates

Making SSL/TLS connections usually needs access to a CA certificate to validate peers. The Mozilla CA bundle can be used via this library. To utilise this certificate bundle, set the following option:
 
`curl_easy_setopt(curl, CURLOPT_CAINFO, LibCURL.cacert)`


