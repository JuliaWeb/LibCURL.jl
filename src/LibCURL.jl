VERSION >= v"0.4.0" && __precompile__(true)

module LibCURL

typealias time_t Int
typealias size_t Csize_t
typealias curl_off_t Int64

include("lC_exports_h.jl")
include("lC_common_h.jl")

@unix_only const libcurl = "libcurl"
@windows_only const libcurl = Pkg.dir("WinRPM","deps","usr","$(Sys.ARCH)-w64-mingw32","sys-root","mingw","bin","libcurl-4")

include("lC_curl_h.jl")

curl_easy_setopt(handle, opt, ptrval::Array) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{Void}), handle, opt, pointer(ptrval))
curl_easy_setopt(handle, opt, ptrval::Integer) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Clong), handle, opt, ptrval)
curl_easy_setopt{T}(handle, opt, ptrval::Ptr{T}) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{T}), handle, opt, ptrval)
curl_easy_setopt(handle, opt, ptrval::AbstractString) = ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{UInt8}), handle, opt, ptrval)

curl_multi_setopt(handle, opt, ptrval::Array) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{Void}), handle, opt, pointer(ptrval))
curl_multi_setopt(handle, opt, ptrval::Integer) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Clong), handle, opt, ptrval)
curl_multi_setopt{T}(handle, opt, ptrval::Ptr{T}) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{T}), handle, opt, ptrval)
curl_multi_setopt(handle, opt, ptrval::AbstractString) = ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Ptr{UInt8}), handle, opt, ptrval)

curl_easy_getinfo(handle, opt, ptrval::Array) = ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{Void}), handle, opt, pointer(ptrval))
curl_easy_getinfo(handle, opt, ptrval::AbstractString) = ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Ptr{UInt8}), handle, opt, ptrval)

include("lC_defines_h.jl")

include("Mime_ext.jl")
export Mime_ext

end
