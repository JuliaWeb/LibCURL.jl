
module LibCURL

using LibCURL_jll
using MozillaCACerts_jll

const time_t = Int
const size_t = Csize_t
const curl_off_t = Int64
const fd_set = Union{}
const socklen_t = Int32

const cacert = MozillaCACerts_jll.cacert

export Mime_ext

include("lC_exports_h.jl")
include("lC_common_h.jl")
include("lC_curl_h.jl")

curl_easy_setopt(handle, opt, ptrval::Array) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{Cvoid}), handle, opt, pointer(ptrval))
curl_easy_setopt(handle, opt, ptrval::Integer) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Clong), handle, opt, ptrval)
curl_easy_setopt(handle, opt, ptrval::Ptr{T}) where {T} = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{T}), handle, opt, ptrval)
curl_easy_setopt(handle, opt, ptrval::AbstractString) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{UInt8}), handle, opt, ptrval)

curl_multi_setopt(handle, opt, ptrval::Array) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{Cvoid}), handle, opt, pointer(ptrval))
curl_multi_setopt(handle, opt, ptrval::Integer) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Clong), handle, opt, ptrval)
curl_multi_setopt(handle, opt, ptrval::Ptr{T}) where {T} = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{T}), handle, opt, ptrval)
curl_multi_setopt(handle, opt, ptrval::AbstractString) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{UInt8}), handle, opt, ptrval)

curl_easy_getinfo(handle, opt, ptrval::Array) = ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{Cvoid}), handle, opt, pointer(ptrval))
curl_easy_getinfo(handle, opt, ptrval::AbstractString) = ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{UInt8}), handle, opt, ptrval)

include("lC_defines_h.jl")

include("Mime_ext.jl")

end
