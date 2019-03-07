# Possible certificate files; stop after finding one
const cert_files = [
    # Debian/Ubuntu/Gentoo etc.
    "/etc/ssl/certs/ca-certificates.crt",
    # Fedora/RHEL 6
    "/etc/pki/tls/certs/ca-bundle.crt",
    # OpenSUSE
    "/etc/ssl/ca-bundle.pem",
    # OpenELEC
    "/etc/pki/tls/cacert.pem",
    # CentOS/RHEL 7
    "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem",
    # macOS (OpenSSL Bomebrew Install)
    "/usr/local/etc/openssl/cert.pem",
    # macOS
    "/etc/ssl/cert.pem",
]

# Possible directories with certificate files; stop afer successfully reading at least
# one file from a directory
const cert_directories = [
    # SLES10/SLES11
    "/etc/ssl/certs/",
    # Android
    "/system/etc/security/cacerts",
    # FreeBSD
    "/usr/local/share/certs",
    # Fedora/RHEL
    "/etc/pki/tls/certs",
    # NetBSD
    "/etc/openssl/certs",
    # AIX
    "/var/ssl/certs",
]

"""
    CACertFile

The `CACertFile` type represents a path to a `.pem` or `.crt` file to be used as a
Certificate Authority Certificate for SSL/TLS requests.
"""
struct CACertFile
    path::AbstractString
    CACertFile(path::AbstractString) = new(path)
end

"""
    CACertPath

The `CACertPath` type represents a path to a directory containing `.pem` or `.crt` files
to be used as Certificate Authority Certificates for SSL/TLS requests.
"""
struct CACertPath
    path::AbstractString
    CACertPath(path::AbstractString) = new(path)
end

"""
    find_system_cacert() -> Union{CACertFile, CACertPath, Nothing}

Search the filesystem for common locations of installed Certificate Authority Certificates.
Will return a `CACertFile` if a specific file is found, or a `CACertPath` if a specific
directory contains certificates is found. Will return `nothing` if nothing is found.
"""
function find_system_cacert()
    # Check if a cert file exists
    for f in cert_files
        if isfile(f)
            # If a cert location exists, return it
            return CACertFile(f)
        end
    end

    # Check if a cert directory exists and has files in it
    for f in cert_directories
        if isdir(f)
            dirfiles = readdir(f)
            if length(dirfiles) > 0
                return CACertPath(f)
            end
        end
    end

    # If we didn't find any system certs, return Nothing
    return nothing
end

"""
    enable_cacert(handle, cert::CACertFile)

Apply the `CACertFile` path to the `CURLOPT_CAINFO` argument of the passed in `curl` handle.
"""
function enable_cacert(handle, cert::CACertFile)
    curl_easy_setopt(handle, CURLOPT_CAINFO, cert.path)
end

"""
    enable_cacert(handle, cert::CACertPath)

Apply the `CACertPath` path to the `CURLOPT_CAPATH` argument of the passed in `curl` handle.
"""
function enable_cacert(handle, cert::CACertPath)
    curl_easy_setopt(handle, CURLOPT_CAPATH, cert.path)
end
