using BinaryProvider # requires BinaryProvider 0.5.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = LibraryProduct[]

dependencies = [
    "https://github.com/bicycle1885/ZlibBuilder/releases/download/v1.0.4/build_Zlib.v1.2.11.jl",
    "https://github.com/JuliaWeb/MbedTLSBuilder/releases/download/v0.20.0/build_MbedTLS.v2.6.1.jl",
    "https://github.com/JuliaWeb/LibCURLBuilder/releases/download/v0.5.1/build_LibCURL.v7.64.1.jl",
]

for dependency in dependencies
    file = joinpath(@__DIR__, basename(dependency))

    # Use the BinaryProvider download function as it supports proxies.
    # See: https://github.com/JuliaWeb/LibCURL.jl/issues/69
    isfile(file) || BinaryProvider.download(dependency, file)

    # Build the dependencies
    # Note: It is a bit faster to run the build in an anonymous module instead of starting a new
    # julia process
    m = @eval module Anon end
    m.include(file)
    append!(products, m.products)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
