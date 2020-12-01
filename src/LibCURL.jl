
module LibCURL

using LibCURL_jll
using MozillaCACerts_jll

const time_t = Int
const size_t = Csize_t
const curl_off_t = Int64
const fd_set = Union{}
const socklen_t = Int32

cacert = ""

export Mime_ext

function __init__()
    # Note: `MozillaCACerts_jll.cacert` is filled by `__init__` which requires LibCURL's
    # copy to also be filled in during initialization. Doing this ensures compatibility
    # with building system images.
    global cacert = MozillaCACerts_jll.cacert
end

include("lC_exports_h.jl")
include("lC_common_h.jl")
include("lC_curl_h.jl")

# curl_easy_getinfo, curl_easy_setopt, and curl_multi_setopt are vararg C functions

curl_easy_setopt(handle, opt, ptrval::Array{T}) where T = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{T}...), handle, opt, ptrval)
curl_easy_setopt(handle, opt, ptrval::Integer) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Clong...), handle, opt, ptrval)
curl_easy_setopt(handle, opt, ptrval::Ptr{T}) where {T} = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{T}...), handle, opt, ptrval)
curl_easy_setopt(handle, opt, ptrval::AbstractString) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{UInt8}...), handle, opt, ptrval)

curl_multi_setopt(handle, opt, ptrval::Array{T}) where T = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{T}...), handle, opt, ptrval)
curl_multi_setopt(handle, opt, ptrval::Integer) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Clong...), handle, opt, ptrval)
curl_multi_setopt(handle, opt, ptrval::Ptr{T}) where {T} = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{T}...), handle, opt, ptrval)
curl_multi_setopt(handle, opt, ptrval::AbstractString) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{UInt8}...), handle, opt, ptrval)

curl_easy_getinfo(handle, opt, ptrval::Array{T}) where T = ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{T}...), handle, opt, ptrval)
curl_easy_getinfo(handle, opt, ptrval::AbstractString) = ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{UInt8}...), handle, opt, ptrval)

include("lC_defines_h.jl")

include("Mime_ext.jl")

end
