module LibCURL

using LibCURL_jll
using MozillaCACerts_jll

cacert = ""

export Mime_ext

function __init__()
    # Note: `MozillaCACerts_jll.cacert` is filled by `__init__` which requires LibCURL's
    # copy to also be filled in during initialization. Doing this ensures compatibility
    # with building system images.
    global cacert = MozillaCACerts_jll.cacert
end

const IS_LIBC_MUSL = occursin("musl", Base.BUILD_TRIPLET)

if Sys.isapple() && Sys.ARCH === :aarch64
    include("../lib/aarch64-apple-darwin20.jl")
elseif Sys.islinux() && Sys.ARCH === :aarch64 && !IS_LIBC_MUSL
    include("../lib/aarch64-linux-gnu.jl")
elseif Sys.islinux() && Sys.ARCH === :aarch64 && IS_LIBC_MUSL
    include("../lib/aarch64-linux-musl.jl")
elseif Sys.islinux() && startswith(string(Sys.ARCH), "arm") && !IS_LIBC_MUSL
    include("../lib/armv7l-linux-gnueabihf.jl")
elseif Sys.islinux() && startswith(string(Sys.ARCH), "arm") && IS_LIBC_MUSL
    include("../lib/armv7l-linux-musleabihf.jl")
elseif Sys.islinux() && Sys.ARCH === :i686 && !IS_LIBC_MUSL
    include("../lib/i686-linux-gnu.jl")
elseif Sys.islinux() && Sys.ARCH === :i686 && IS_LIBC_MUSL
    include("../lib/i686-linux-musl.jl")
elseif Sys.iswindows() && Sys.ARCH === :i686
    include("../lib/i686-w64-mingw32.jl")
elseif Sys.islinux() && Sys.ARCH === :powerpc64le
    include("../lib/powerpc64le-linux-gnu.jl")
elseif Sys.isapple() && Sys.ARCH === :x86_64
    include("../lib/x86_64-apple-darwin14.jl")
elseif Sys.islinux() && Sys.ARCH === :x86_64 && !IS_LIBC_MUSL
    include("../lib/x86_64-linux-gnu.jl")
elseif Sys.islinux() && Sys.ARCH === :x86_64 && IS_LIBC_MUSL
    include("../lib/x86_64-linux-musl.jl")
elseif Sys.isbsd() && !Sys.isapple()
    include("../lib/x86_64-unknown-freebsd11.1.jl")
elseif Sys.iswindows() && Sys.ARCH === :x86_64
    include("../lib/x86_64-w64-mingw32.jl")
else
    error("Unknown platform: $(Base.BUILD_TRIPLET)")
end

# curl_share_setopt, curl_easy_getinfo, curl_easy_setopt, and curl_multi_setopt are vararg C functions
curl_share_setopt(handle, opt, param) = ccall((:curl_share_setopt, libcurl), CURLSHcode, (Ptr{CURLSH}, CURLSHoption, Any...), handle, opt, param)

curl_easy_setopt(handle, opt, ptrval::Array{T}) where T = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{T}...), handle, opt, ptrval)
curl_easy_setopt(handle, opt, ptrval::Integer) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Clong...), handle, opt, ptrval)
curl_easy_setopt(handle, opt, ptrval::Ptr{T}) where {T} = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{T}...), handle, opt, ptrval)
curl_easy_setopt(handle, opt, ptrval::AbstractString) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{UInt8}...), handle, opt, ptrval)
curl_easy_setopt(handle, opt, param) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Any...), handle, opt, param)

curl_multi_setopt(handle, opt, ptrval::Array{T}) where T = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{T}...), handle, opt, ptrval)
curl_multi_setopt(handle, opt, ptrval::Integer) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Clong...), handle, opt, ptrval)
curl_multi_setopt(handle, opt, ptrval::Ptr{T}) where {T} = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{T}...), handle, opt, ptrval)
curl_multi_setopt(handle, opt, ptrval::AbstractString) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{UInt8}...), handle, opt, ptrval)
curl_multi_setopt(multi_handle, opt, param) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Any...), multi_handle, opt, param)

curl_easy_getinfo(handle, opt, ptrval::Array{T}) where T = ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{T}...), handle, opt, ptrval)
curl_easy_getinfo(handle, opt, ptrval::AbstractString) = ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{UInt8}...), handle, opt, ptrval)
curl_easy_getinfo(handle, info, arg) = ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLINFO, Any...), handle, info, arg)

include("Mime_ext.jl")

# exports
const PREFIXES = ["curl_", "CURLOPT_", "CURLFORM_", "CURLE_", "CURLINFO_", "CURLSSH_", "CURLAUTH_", "CURLM", "CURL"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
