using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libcurl"], :libcurl),
]

# Install BinaryBuilder dependencies
dependencies = [
    "https://github.com/bicycle1885/ZlibBuilder/releases/download/v1.0.3/build_Zlib.v1.2.11.jl",
    "https://github.com/JuliaWeb/MbedTLSBuilder/releases/download/v0.17.0/build_MbedTLS.v2.16.0.jl"
]

for url in dependencies
    build_file = joinpath(@__DIR__, basename(url))
    if !isfile(build_file)
        download(url, build_file)
    end
end

# Execute the build scripts for the dependencies in an isolated module to avoid overwriting
# any variables/constants here
for url in dependencies
    build_file = joinpath(@__DIR__, basename(url))
    m = @eval module $(gensym()); include($build_file); end
    append!(products, m.products)
end

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaWeb/LibCURLBuilder/releases/download/v0.4.0"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc) => ("$bin_prefix/LibCURL.v7.64.0.aarch64-linux-gnu.tar.gz", "7a8ebe6cf660f549a48a866878b45eb50c81e02c838701e84af4d38fa51b2e64"),
    Linux(:aarch64, libc=:musl) => ("$bin_prefix/LibCURL.v7.64.0.aarch64-linux-musl.tar.gz", "3523d4029bbb41d21c7986e15dfff83bdbe3489e4d567a4b34a031b690cf749c"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf) => ("$bin_prefix/LibCURL.v7.64.0.arm-linux-gnueabihf.tar.gz", "d48fffc0a37b80be47ab84a24511b3254d74a4dcd3063efd45358615fec0bac3"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf) => ("$bin_prefix/LibCURL.v7.64.0.arm-linux-musleabihf.tar.gz", "0f6c6ffaa90f80a666ba781ca174dc2b2be4396ef2c7cf8a8a8666f699ab0669"),
    Linux(:i686, libc=:glibc) => ("$bin_prefix/LibCURL.v7.64.0.i686-linux-gnu.tar.gz", "c48a6410722172d686d79a202f38415b3a3ce295c1f2cdaf434dff055a289e32"),
    Linux(:i686, libc=:musl) => ("$bin_prefix/LibCURL.v7.64.0.i686-linux-musl.tar.gz", "9de6cc36c00b0ca8477f4286f8f354ebd512c85196fb8a13ad62b2b91b3e7b2a"),
    Windows(:i686) => ("$bin_prefix/LibCURL.v7.64.0.i686-w64-mingw32.tar.gz", "74ae4f83d2994f3cb965ade2ab5096dd87d15444c6a5c7e03c83d7a6b45d5ac5"),
    Linux(:powerpc64le, libc=:glibc) => ("$bin_prefix/LibCURL.v7.64.0.powerpc64le-linux-gnu.tar.gz", "7ab7c5a8a8d4b3f988f46a3a8cc9ea84b919fa2ba8084cc17ce67c88813d5e3f"),
    MacOS(:x86_64) => ("$bin_prefix/LibCURL.v7.64.0.x86_64-apple-darwin14.tar.gz", "f1bafda02054986c28f6a813623d2cafdf7cacaf3f6f66e1f5e4761a2257855e"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/LibCURL.v7.64.0.x86_64-linux-gnu.tar.gz", "fed9e12416e7a145de848d022d91269a77ac8389344fe20c77721eaf15357c20"),
    Linux(:x86_64, libc=:musl) => ("$bin_prefix/LibCURL.v7.64.0.x86_64-linux-musl.tar.gz", "80629759d93125e4547a6a3a444a43cceb7da36691100dc69b1480fddca7bb5d"),
    Windows(:x86_64) => ("$bin_prefix/LibCURL.v7.64.0.x86_64-w64-mingw32.tar.gz", "4b02ad8bfff69fcb059e7260c5166f7330b13b514c9f830116009047d142b764"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)

