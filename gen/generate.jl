using Pkg
using Pkg.Artifacts
using Clang.Generators
using Clang.Generators.JLLEnvs
using LibCURL_jll

cd(@__DIR__)

artifact_toml = joinpath(dirname(pathof(LibCURL_jll)), "..", "StdlibArtifacts.toml")
artifact_dir = Pkg.Artifacts.ensure_artifact_installed("LibCURL", artifact_toml)

include_dir = joinpath(artifact_dir, "include") |> normpath
curl_h = joinpath(include_dir, "curl", "curl.h")
@assert isfile(curl_h)

# mprintf_h = joinpath(include_dir, "curl", "mprintf.h")
# stdcheaders_h = joinpath(include_dir, "curl", "stdcheaders.h")

options = load_options(joinpath(@__DIR__, "generator.toml"))

for target in JLLEnvs.JLL_ENV_TRIPLES
    @info "processing $target"

    options["general"]["output_file_path"] = joinpath(@__DIR__, "..", "lib", "$target.jl")

    args = get_default_args(target)
    push!(args, "-I$include_dir")
    # Disable typecheck macros that shadow variadic functions
    push!(args, "-D__STDC__=0", "-DCURL_DISABLE_TYPECHECK")

    # header_files = detect_headers(include_dir, args)
    header_files = [curl_h]

    ctx = create_context(header_files, args, options)

    build!(ctx)
end
