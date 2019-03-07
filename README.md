LibCURL.jl
==========

*Julia wrapper for libCURL*

[![Build Status](https://travis-ci.org/JuliaWeb/LibCURL.jl.svg?branch=master)](https://travis-ci.org/JuliaWeb/LibCURL.jl)
[![Appveyor](https://ci.appveyor.com/api/projects/status/github/JuliaWeb/LibCurl.jl?svg=true)](https://ci.appveyor.com/project/shashi/libcurl-jl)
[![codecov.io](http://codecov.io/github/JuliaWeb/LibCURL.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaWeb/LibCURL.jl?branch=master)

[![LibCURL](http://pkg.julialang.org/badges/LibCURL_0.4.svg)](http://pkg.julialang.org/?pkg=LibCURL&ver=0.4)
[![LibCURL](http://pkg.julialang.org/badges/LibCURL_0.5.svg)](http://pkg.julialang.org/?pkg=LibCURL&ver=0.5)
[![LibCURL](http://pkg.julialang.org/badges/LibCURL_0.6.svg)](http://pkg.julialang.org/?pkg=LibCURL&ver=0.6)

---
This is a simple Julia wrapper around http://curl.haxx.se/libcurl/ generated using [Clang.jl](https://github.com/ihnorton/Clang.jl).

### Example (fetch a URL)

```julia
using LibCURL

# init a curl handle
curl = curl_easy_init()

# set the URL and request to follow redirects
curl_easy_setopt(curl, CURLOPT_URL, "http://example.com")
curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)


# setup the callback function to recv data
function curl_write_cb(curlbuf::Ptr{Void}, s::Csize_t, n::Csize_t, p_ctxt::Ptr{Void})
    sz = s * n
    data = Array{UInt8}(sz)

    ccall(:memcpy, Ptr{Void}, (Ptr{Void}, Ptr{Void}, UInt64), data, curlbuf, sz)
    println("recd: ", String(data))

    sz::Csize_t
end

c_curl_write_cb = cfunction(curl_write_cb, Csize_t, (Ptr{Void}, Csize_t, Csize_t, Ptr{Void}))
curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, c_curl_write_cb)


# execute the query
res = curl_easy_perform(curl)
println("curl url exec response : ", res)

# retrieve HTTP code
http_code = Array{Clong}(1)
curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, http_code)
println("httpcode : ", http_code)

# release handle
curl_easy_cleanup(curl)

```

### Using CACerts for SSL/TLS Authentication

If you want LibCURL to attempt to find a system CACert you can run:

```julia
# find_system_cert will return either a CACertFile or a CACertPath depending on
# what kind of system certificate(s) it finds.
# This function will return nothing if it can't find any system certificates
cacert = find_system_cacert()

if cacert !== nothing
    enable_cacert(curl, cacert)
end
```

You can also specify your own cacert if need be.

```julia
# You can either specify a specific certificate file
cacert = CACertFile("path/to/cert.pem")
enable_cacert(curl, cacert)

# Or you can specify a folder that contains certificates
cacert = CACertPath("path/to/certs")
enable_cacert(curl, cacert)
```
