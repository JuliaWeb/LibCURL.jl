module libCURL

include("lC_exports_h.jl")
include("lC_common_h.jl")

@ctypedef time_t Int32

libcurl = :libcurl

include("lC_curl_h.jl")

@c CURLcode curl_easy_setopt (Ptr{CURL}, CURLoption, Int...) libcurl
@c CURLcode curl_easy_setopt (Ptr{CURL}, CURLoption,Ptr{Void}...) libcurl
@c CURLcode curl_easy_setopt (Ptr{CURL}, CURLoption,Ptr{Uint8}...) libcurl

@c CURLcode curl_easy_getinfo (Ptr{CURL}, CURLoption,Ptr{Int}...) libcurl
@c CURLcode curl_easy_getinfo (Ptr{CURL}, CURLoption,Ptr{Float64}...) libcurl
@c CURLcode curl_easy_getinfo (Ptr{CURL}, CURLoption,Ptr{Uint8}...) libcurl

include("lC_defines_h.jl")

end