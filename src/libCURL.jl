module libCURL

typealias time_t Int
typealias size_t Csize_t
typealias curl_off_t Int64

include("lC_exports_h.jl")
include("lC_common_h.jl")


libcurl = :libcurl

include("lC_curl_h.jl")

@c CURLcode curl_easy_setopt (Ptr{CURL}, CURLoption, Int...) libcurl
@c CURLcode curl_easy_setopt (Ptr{CURL}, CURLoption,Ptr{Void}...) libcurl
@c CURLcode curl_easy_setopt (Ptr{CURL}, CURLoption,Ptr{Uint8}...) libcurl

@c CURLcode curl_multi_setopt (Ptr{CURL}, CURLoption, Int...) libcurl
@c CURLcode curl_multi_setopt (Ptr{CURL}, CURLoption,Ptr{Void}...) libcurl
@c CURLcode curl_multi_setopt (Ptr{CURL}, CURLoption,Ptr{Uint8}...) libcurl

@c CURLcode curl_easy_getinfo (Ptr{CURL}, CURLoption,Ptr{Int}...) libcurl
@c CURLcode curl_easy_getinfo (Ptr{CURL}, CURLoption,Ptr{Float64}...) libcurl
@c CURLcode curl_easy_getinfo (Ptr{CURL}, CURLoption,Ptr{Uint8}...) libcurl

include("lC_defines_h.jl")

include("Mime_ext.jl")
export Mime_ext

include("HTTPC.jl")
export HTTPC

end
