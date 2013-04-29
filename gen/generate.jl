using Clang.cindex
using Clang.wrap_c

JULIAHOME=EnvHash()["JULIAHOME"]

clang_includes = map(x->joinpath(JULIAHOME, x), [
  "deps/llvm-3.2/build/Release/lib/clang/3.2/include",
  "deps/llvm-3.2/include",
  "deps/llvm-3.2/include",
  "deps/llvm-3.2/build/include/",
  "deps/llvm-3.2/include/"
  ])
clang_extraargs = ["-D", "__STDC_LIMIT_MACROS", "-D", "__STDC_CONSTANT_MACROS"]

wrap_hdrs = map( x-> joinpath("/usr/include/curl", x), [ "curl.h", "easy.h", "multi.h" ])

wc = wrap_c.init(".", "../src/lC_common_h.jl", clang_includes, clang_extraargs, (th, h) -> contains(wrap_hdrs, h) , h -> "libcurl", h -> "../src/lC_" * replace(last(split(h, "/")), ".", "_")  * ".jl" )
wc.options.wrap_structs = true

wrap_c.wrap_c_headers(wc, ["/usr/include/curl/curl.h"])

# generate export statements.....
fe = open("../src/lC_exports_h.jl", "w+")
println(fe, "#   Generating exports")

fc = open("../src/lC_curl_h.jl", "r")
curljl = split(readall(fc), "\n")
close(fc)

for e in curljl
  m = match(r"^\s*\@c\s+[\w\:\{\}\_]+\s+(\w+)", e)
  if (m != nothing) 
#    println (m.captures[1])
    @printf fe "export %s\n"  m.captures[1]
  end
end

fc = open("../src/lC_common_h.jl", "r")
curljl = split(readall(fc), "\n")
close(fc)

for e in curljl
  m = match(r"^\s*\@ctypedef\s+(\w+)", e)
  if (m != nothing) 
#    println(m.captures[1])
    @printf fe "export %s\n"  m.captures[1]
  else 
    m = match(r"^\s*const\s+(\w+)", e)
    if (m != nothing) 
#        println(m.captures[1])
        @printf fe "export %s\n"  m.captures[1]
    end
  end
end



# #defines generated
const ign_defs = [
  "_PULL_SYS_TYPES_H",
  "_PULL_STDINT_H",
  "_PULL_INTTYPES_H",
  "_PULL_SYS_SOCKET_H",
  "_SIZEOF_LONG",
  "_TYPEOF_CURL_SOCKLEN_T",
  "_SIZEOF_CURL_SOCKLEN_T",
  "_TYPEOF_CURL_OFF_T",
  "_FORMAT_CURL_OFF_T",
  "_FORMAT_CURL_OFF_TU",
  "_FORMAT_OFF_T",
  "_SIZEOF_CURL_OFF_T",
  "_SUFFIX_CURL_OFF_T",
  "_SUFFIX_CURL_OFF_TU"
]


f = open("../src/lC_defines_h.jl", "w+")
println(f, "#   Generating #define constants")

hashdefs = split(readall(`gcc -E -dD -P /usr/include/curl/curl.h`), "\n")
for e in hashdefs
  m = match(r"^\s*#define\s+CURL(\w+)\s+(.+)", e)
  if (m != nothing) && !contains(ign_defs, strip(m.captures[1]))
    c2 = replace (m.captures[2], "(unsigned long)", "") 
    @printf f "const CURL%-30s = %s\n"  m.captures[1]  c2
    @printf fe "export CURL%s\n"  m.captures[1]
  end
end

close(f)
close(fe)


# Generate the File extension to MIME type mapping.
f = open("../src/Mime_ext.jl", "w+")
write(f, "module Mime_ext\n\nexport MimeExt\n\nMimeExt = {\n")

mimes = split(open(readall, "/etc/mime.types"), "\n")
for e in mimes
  m = match(r"^\s*#", e)
  if (m == nothing)
    tokens = split(e)
    if (length(tokens) > 1)
        for i = 2:length(tokens)
            write (f, "  \"$(tokens[i])\" => \"$(tokens[1])\",\n")
        end
    end
  end
end

write(f, "  \"\" => \"\"\n}\n\nend\n")
close(f)


