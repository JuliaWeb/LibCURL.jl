using BinDeps
import Compat: is_windows

@BinDeps.setup

if is_windows()
    # note that there is a 32-bit version of libcurl.dll
    # included with Git, which will not work with 64 bit Julia

    libcurl = library_dependency("libcurl-4", aliases = ["libcurl4"])
    using WinRPM
    provides(WinRPM.RPM, "libcurl4", libcurl, os = :Windows)
end

@BinDeps.install
