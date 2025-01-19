LibCURL.jl
==========

*Julia wrapper for libCURL*

[![CI](https://github.com/JuliaWeb/LibCURL.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/JuliaWeb/LibCURL.jl/actions/workflows/ci.yml)
[![codecov.io](https://codecov.io/github/JuliaWeb/LibCURL.jl/graph/badge.svg)](https://codecov.io/github/JuliaWeb/LibCURL.jl)

---
This is a simple Julia wrapper around http://curl.haxx.se/libcurl/ generated using [Clang.jl](https://github.com/ihnorton/Clang.jl). Please see the [libcurl API documentation](https://curl.haxx.se/libcurl/c/) for help on how to use this package.

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

This package also uses the [MozillaCACerts_jll](https://github.com/JuliaBinaryWrappers/MozillaCACerts_jll.jl) package to supply the Mozilla CA root certificate bundle. Note that the `cacert` symbol is re-exported from this package for ease of use.

* `cacert`: A `FileProduct` referencing the Mozilla CA certificate bundle

### SSL certificates

Making SSL/TLS connections usually needs access to a CA certificate to validate peers. The Mozilla CA bundle can be used via this package. To use this certificate bundle, set the following option:

```julia
curl_easy_setopt(curl, CURLOPT_CAINFO, LibCURL.cacert)
```
