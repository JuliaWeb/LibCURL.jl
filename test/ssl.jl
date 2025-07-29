# Test that https://www.google.com successfully connects
curl = curl_easy_init()
curl == C_NULL && error("curl_easy_init() failed")

# Setup the callback function to recv data
function curl_write_cb(curlbuf::Ptr{Cvoid}, s::Csize_t, n::Csize_t, p_ctxt::Ptr{Cvoid})
    sz = s * n
    data = Array{UInt8}(undef, sz)
    ccall(:memcpy, Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, Csize_t), data, curlbuf, sz)
    return sz::Csize_t
end

# Setup the callback function to collect debug information
const infotype_str = Dict(
    0 => "CURLINFO_TEXT",
    1 => "CURLINFO_HEADER_IN",
    2 => "CURLINFO_HEADER_OUT",
    3 => "CURLINFO_DATA_IN",
    4 => "CURLINFO_DATA_OUT",
    5 => "CURLINFO_SSL_DATA_IN",
    6 => "CURLINFO_SSL_DATA_OUT",
)

function curl_debug_cb(handle::Ptr{Cvoid}, type::Cint, data::Ptr{Cvoid}, sz::Csize_t, clientp::Ptr{Cvoid})
    debug_buffer = unsafe_pointer_to_objref(clientp)::IOBuffer
    data = UInt8[unsafe_load(reinterpret(Ptr{Cuchar}, data), n) for n in 1:sz]
    println(debug_buffer, "$(infotype_str[type]) \"$(String(data))\"")
    return Cint(0)
end

@testset "SSL verify" begin
    # Set up the write function to consume the curl output so we don't see it in the
    # test output
    c_curl_write_cb = @cfunction(
        curl_write_cb,
        Csize_t,
        (Ptr{Cvoid}, Csize_t, Csize_t, Ptr{Cvoid})
    )
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, c_curl_write_cb)

    # Set up our SSL options
    curl_easy_setopt(curl, CURLOPT_URL, "https://www.google.com")
    curl_easy_setopt(curl, CURLOPT_USE_SSL, CURLUSESSL_ALL)
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 2)
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 1)
    curl_easy_setopt(curl, CURLOPT_CAINFO, LibCURL.cacert)

    # For debugging -- we see that `res ≠ CURLE_OK` below and want to know why
    curl_easy_setopt(curl, CURLOPT_VERBOSE, 1)
    c_curl_debug_cb = @cfunction(
        curl_debug_cb,
        Cint,
        (Ptr{Cvoid}, Cint, Ptr{Cvoid}, Csize_t, Ptr{Cvoid})
    )
    debug_buffer = IOBuffer()
    GC.@preserve debug_buffer begin
        curl_easy_setopt(curl, CURLOPT_DEBUGFUNCTION, c_curl_debug_cb)
        curl_easy_setopt(curl, CURLOPT_DEBUGDATA, pointer_from_objref(debug_buffer))

        @testset "SSL Success" begin
            res = curl_easy_perform(curl)
            if !(res == CURLE_OK)
                println("CURL debug output:\n")
                print(takestring!(debug_buffer))
            end
            @test res == CURLE_OK
        end
    end
end

curl_easy_cleanup(curl)
