module libCURL


include("lC_common_h.jl")

@ctypedef time_t Int32
@ctypedef CURLMcode Int32

include("lC_curl_h.jl")
include("lC_defines_h.jl")

end