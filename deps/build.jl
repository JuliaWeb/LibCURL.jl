using BinDeps

@BinDeps.setup

@windows_only begin
# note that there is a 32-bit version of libcurl.dll
# included with Git, which will not work with 64 bit Julia
libcurl = library_dependency("libcurl", aliases = ["libcurl-4"])
using WinRPM
provides(WinRPM.RPM, "libcurl", libcurl, os = :Windows)
end

@BinDeps.install
