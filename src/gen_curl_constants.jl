#! /usr/bin/env julia

# Run the C preproessor on curl.h for #defines...
using Clang.cindex

const ENUM_DECL = 5
const TYPEDEF_DECL = 20


f = open("curl_defs.jl", "w+")





enum_remaps = {
  "CXCursor_" => ("", uppercase),
  "CXType_" => ("", uppercase)
}


function wrap_enums(io::IOStream, cu::cindex.CXCursor, typedef::Any)
  enum = cindex.name(cu)
  enum_typedef = if (typeof(typedef) == cindex.CXCursor)
    cindex.name(typedef)
  else
    ""
  end
  if enum != ""
    println(io, "# enum ENUM_", enum)
  elseif enum_typedef != ""
    println(io, "# enum ", enum_typedef)
  else
    println(io, "# enum (ANONYMOUS)")
  end
  
  cl = cindex.children(cu)

  remap_name = 1
  remap_f = identity
  for k in keys(enum_remaps)
    if (ismatch(Regex("$k*"), cindex.name(cindex.ref(cl,1))) )
      remap_name = length(k)
      remap_f = enum_remaps[k][2]
      break
    end
  end
  for i=1:cl.size
    cur_cu = cindex.ref(cl,i)
    name = cindex.spelling(cur_cu)
    if (length(name) < 1) continue end
    if (remap_name>1) name = remap_f(name[remap_name+1:end]) end

    println(io, "const ", name, " = ", cindex.value(cur_cu))
  end
  cindex.cl_dispose(cl)
  println(io, "# end")
  if enum != "" && enum_typedef != ""
      println(io, "# const $(enum_typedef) == ENUM_$(enum)")
  end
  println(io)
end

fn = "/usr/include/curl/curl.h"
tu = cindex.tu_init(fn)
topcu = cindex.tu_cursor(tu)
topcl = cindex.children(topcu)
println(f, "# Automatically generated from ", fn)
println(f, "#   using dumpenums.jl")
for i = 1:topcl.size
  cu = cindex.ref(topcl,i)
  fn_current = cindex.cu_file(cu)
  if (fn != fn_current) continue end
  if (cindex.cu_kind(cu) == ENUM_DECL)
    tdcu = cindex.ref(topcl,i+1)
    tdcu = ((cindex.cu_kind(tdcu) == TYPEDEF_DECL) ? tdcu : None)
    wrap_enums(f, cu, tdcu)
  end
end

fn = "/usr/include/curl/multi.h"
tu = cindex.tu_init(fn)
topcu = cindex.tu_cursor(tu)
topcl = cindex.children(topcu)
println(f, "# Automatically generated from ", fn)
println(f, "#   using dumpenums.jl")
for i = 1:topcl.size
  cu = cindex.ref(topcl,i)
  fn_current = cindex.cu_file(cu)
  if (fn != fn_current) continue end
  if (cindex.cu_kind(cu) == ENUM_DECL)
    tdcu = cindex.ref(topcl,i+1)
    tdcu = ((cindex.cu_kind(tdcu) == TYPEDEF_DECL) ? tdcu : None)
    wrap_enums(f, cu, tdcu)
  end
end




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


hashdefs = split(readall(`gcc -E -dD -P /usr/include/curl/curl.h`), "\n")
for e in hashdefs
#  m = match(r"^\s*#define\s+CURL(\w+)\s+([\w\(\)\<\>\|\"]+)", e)
  m = match(r"^\s*#define\s+CURL(\w+)\s+(.+)", e)
  if (m != nothing) && !contains(ign_defs, strip(m.captures[1]))
    println (m.captures)
    c2 = replace (m.captures[2], "(unsigned long)", "") 
    @printf f "const CURL%-30s = %s\n"  m.captures[1]  c2
  end
end




close(f)


