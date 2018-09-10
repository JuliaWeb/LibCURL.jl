using Clang.cindex
using Clang.wrap_c
using Printf

# Set these to correspond to your local filesystem's curl and clang include paths
const CURL_PATH = "/usr/local/opt/curl/include/curl"
const CLANG_INCLUDES = [
    "/usr/local/opt/llvm/include",
]

const SRC_DIR = abspath(@__DIR__, "..", "src")

headers = map(x -> joinpath(CURL_PATH, x), ["curl.h", "easy.h", "multi.h"])
context = wrap_c.init(;
    headers = headers,
    clang_args = String[],
    common_file = joinpath(SRC_DIR, "lC_common_h.jl"),
    clang_includes = CLANG_INCLUDES,
    clang_diagnostics = true,
    header_wrapped = (top_header, cursor_header) -> in(cursor_header, headers),
    header_library = header -> "libcurl",
    header_outputfile = header -> joinpath(SRC_DIR, "lC_") * replace(basename(header), "." => "_") * ".jl",
)
context.options.wrap_structs = true

begin
    context.headers = [joinpath(CURL_PATH, "curl.h")]
    run(context)
end

function write_constants(filename::AbstractString, startswith_identifier::AbstractString, exports_file)
    open(filename, "r") do file
        lines = split(read(file, String), "\n")

        for line in lines
            if startswith(line, startswith_identifier)
                @printf exports_file "export %s\n" split(line, r" |\(")[2]
            end
        end
    end
end

# Generate export statements
open(joinpath(SRC_DIR, "lC_exports_h.jl"), "w+") do exports_file
    println(exports_file, "#   Generating exports")

    write_constants(joinpath(SRC_DIR, "lC_curl_h.jl"), "function", exports_file)
    write_constants(joinpath(SRC_DIR, "lC_common_h.jl"), "const", exports_file)

    # Generate define constants
    open(joinpath(SRC_DIR, "lC_defines_h.jl"), "w+") do defines_file
        println(defines_file, "#   Generating #define constants")

        hashdefs = split(read(`gcc -E -dD -P $(joinpath(CURL_PATH, "curl.h"))`, String), "\n")

        for line in hashdefs
            m = match(r"^\s*#define\s+CURL(\w+)\s+(.+)", line)

            if m !== nothing
                c2 = replace(m.captures[2], "(unsigned long)" => "")
                @printf defines_file "const CURL%-30s = %s\n"  m.captures[1]  c2
                @printf exports_file "export CURL%s\n"  m.captures[1]
            end
        end
    end
end
