to_c_type(t::Type) = t
to_c_type_pairs(va_list) = map(enumerate(to_c_type.(va_list))) do (ind, type)
    :(va_list[$ind]::$type)
end

const __time_t = Clong

const __socklen_t = Cuint

const time_t = __time_t

const __fd_mask = Clong

mutable struct fd_set
    __fds_bits::NTuple{16, __fd_mask}
    fd_set() = new()
end

const socklen_t = __socklen_t

const sa_family_t = Cushort

struct sockaddr
    sa_family::sa_family_t
    sa_data::NTuple{14, Cchar}
end

const curl_usessl = UInt32
const CURLUSESSL_NONE = 0 % UInt32
const CURLUSESSL_TRY = 1 % UInt32
const CURLUSESSL_CONTROL = 2 % UInt32
const CURLUSESSL_ALL = 3 % UInt32
const CURLUSESSL_LAST = 4 % UInt32

const CURLM = Cvoid

const curl_socket_t = Cint

const CURLMcode = Int32
const CURLM_CALL_MULTI_PERFORM = -1 % Int32
const CURLM_OK = 0 % Int32
const CURLM_BAD_HANDLE = 1 % Int32
const CURLM_BAD_EASY_HANDLE = 2 % Int32
const CURLM_OUT_OF_MEMORY = 3 % Int32
const CURLM_INTERNAL_ERROR = 4 % Int32
const CURLM_BAD_SOCKET = 5 % Int32
const CURLM_UNKNOWN_OPTION = 6 % Int32
const CURLM_ADDED_ALREADY = 7 % Int32
const CURLM_RECURSIVE_API_CALL = 8 % Int32
const CURLM_WAKEUP_FAILURE = 9 % Int32
const CURLM_BAD_FUNCTION_ARGUMENT = 10 % Int32
const CURLM_LAST = 11 % Int32

function curl_multi_socket_action(multi_handle, s, ev_bitmask, running_handles)
    @ccall libcurl.curl_multi_socket_action(multi_handle::Ptr{CURLM}, s::curl_socket_t, ev_bitmask::Cint, running_handles::Ptr{Cint})::CURLMcode
end

const curl_socklen_t = socklen_t

const curl_off_t = Clong

const CURL = Cvoid

const CURLSH = Cvoid

const curl_sslbackend = UInt32
const CURLSSLBACKEND_NONE = 0 % UInt32
const CURLSSLBACKEND_OPENSSL = 1 % UInt32
const CURLSSLBACKEND_GNUTLS = 2 % UInt32
const CURLSSLBACKEND_NSS = 3 % UInt32
const CURLSSLBACKEND_OBSOLETE4 = 4 % UInt32
const CURLSSLBACKEND_GSKIT = 5 % UInt32
const CURLSSLBACKEND_POLARSSL = 6 % UInt32
const CURLSSLBACKEND_WOLFSSL = 7 % UInt32
const CURLSSLBACKEND_SCHANNEL = 8 % UInt32
const CURLSSLBACKEND_SECURETRANSPORT = 9 % UInt32
const CURLSSLBACKEND_AXTLS = 10 % UInt32
const CURLSSLBACKEND_MBEDTLS = 11 % UInt32
const CURLSSLBACKEND_MESALINK = 12 % UInt32
const CURLSSLBACKEND_BEARSSL = 13 % UInt32

struct curl_httppost
    next::Ptr{curl_httppost}
    name::Ptr{Cchar}
    namelength::Clong
    contents::Ptr{Cchar}
    contentslength::Clong
    buffer::Ptr{Cchar}
    bufferlength::Clong
    contenttype::Ptr{Cchar}
    contentheader::Ptr{Cvoid} # contentheader::Ptr{curl_slist}
    more::Ptr{curl_httppost}
    flags::Clong
    showfilename::Ptr{Cchar}
    userp::Ptr{Cvoid}
    contentlen::curl_off_t
end

function Base.getproperty(x::curl_httppost, f::Symbol)
    f === :contentheader && return Ptr{curl_slist}(getfield(x, f))
    return getfield(x, f)
end

# typedef int ( * curl_progress_callback ) ( void * clientp , double dltotal , double dlnow , double ultotal , double ulnow )
const curl_progress_callback = Ptr{Cvoid}

# typedef int ( * curl_xferinfo_callback ) ( void * clientp , curl_off_t dltotal , curl_off_t dlnow , curl_off_t ultotal , curl_off_t ulnow )
const curl_xferinfo_callback = Ptr{Cvoid}

# typedef size_t ( * curl_write_callback ) ( char * buffer , size_t size , size_t nitems , void * outstream )
const curl_write_callback = Ptr{Cvoid}

# typedef int ( * curl_resolver_start_callback ) ( void * resolver_state , void * reserved , void * userdata )
const curl_resolver_start_callback = Ptr{Cvoid}

const curlfiletype = UInt32
const CURLFILETYPE_FILE = 0 % UInt32
const CURLFILETYPE_DIRECTORY = 1 % UInt32
const CURLFILETYPE_SYMLINK = 2 % UInt32
const CURLFILETYPE_DEVICE_BLOCK = 3 % UInt32
const CURLFILETYPE_DEVICE_CHAR = 4 % UInt32
const CURLFILETYPE_NAMEDPIPE = 5 % UInt32
const CURLFILETYPE_SOCKET = 6 % UInt32
const CURLFILETYPE_DOOR = 7 % UInt32
const CURLFILETYPE_UNKNOWN = 8 % UInt32

mutable struct __JL_Ctag_55
    time::Ptr{Cchar}
    perm::Ptr{Cchar}
    user::Ptr{Cchar}
    group::Ptr{Cchar}
    target::Ptr{Cchar}
    __JL_Ctag_55() = new()
end
function Base.getproperty(x::Ptr{__JL_Ctag_55}, f::Symbol)
    f === :time && return Ptr{Ptr{Cchar}}(x + 0)
    f === :perm && return Ptr{Ptr{Cchar}}(x + 8)
    f === :user && return Ptr{Ptr{Cchar}}(x + 16)
    f === :group && return Ptr{Ptr{Cchar}}(x + 24)
    f === :target && return Ptr{Ptr{Cchar}}(x + 32)
    return getfield(x, f)
end

function Base.getproperty(x::__JL_Ctag_55, f::Symbol)
    r = Ref{__JL_Ctag_55}(x)
    ptr = Base.unsafe_convert(Ptr{__JL_Ctag_55}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{__JL_Ctag_55}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end


struct curl_fileinfo
    data::NTuple{128, UInt8}
end

function Base.getproperty(x::Ptr{curl_fileinfo}, f::Symbol)
    f === :filename && return Ptr{Ptr{Cchar}}(x + 0)
    f === :filetype && return Ptr{curlfiletype}(x + 8)
    f === :time && return Ptr{time_t}(x + 16)
    f === :perm && return Ptr{Cuint}(x + 24)
    f === :uid && return Ptr{Cint}(x + 28)
    f === :gid && return Ptr{Cint}(x + 32)
    f === :size && return Ptr{curl_off_t}(x + 40)
    f === :hardlinks && return Ptr{Clong}(x + 48)
    f === :strings && return Ptr{__JL_Ctag_55}(x + 56)
    f === :flags && return Ptr{Cuint}(x + 96)
    f === :b_data && return Ptr{Ptr{Cchar}}(x + 104)
    f === :b_size && return Ptr{Csize_t}(x + 112)
    f === :b_used && return Ptr{Csize_t}(x + 120)
    return getfield(x, f)
end

function Base.getproperty(x::curl_fileinfo, f::Symbol)
    r = Ref{curl_fileinfo}(x)
    ptr = Base.unsafe_convert(Ptr{curl_fileinfo}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{curl_fileinfo}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

# typedef long ( * curl_chunk_bgn_callback ) ( const void * transfer_info , void * ptr , int remains )
const curl_chunk_bgn_callback = Ptr{Cvoid}

# typedef long ( * curl_chunk_end_callback ) ( void * ptr )
const curl_chunk_end_callback = Ptr{Cvoid}

# typedef int ( * curl_fnmatch_callback ) ( void * ptr , const char * pattern , const char * string )
const curl_fnmatch_callback = Ptr{Cvoid}

# typedef int ( * curl_seek_callback ) ( void * instream , curl_off_t offset , int origin )
const curl_seek_callback = Ptr{Cvoid}

# typedef size_t ( * curl_read_callback ) ( char * buffer , size_t size , size_t nitems , void * instream )
const curl_read_callback = Ptr{Cvoid}

# typedef int ( * curl_trailer_callback ) ( struct curl_slist * * list , void * userdata )
const curl_trailer_callback = Ptr{Cvoid}

const curlsocktype = UInt32
const CURLSOCKTYPE_IPCXN = 0 % UInt32
const CURLSOCKTYPE_ACCEPT = 1 % UInt32
const CURLSOCKTYPE_LAST = 2 % UInt32

# typedef int ( * curl_sockopt_callback ) ( void * clientp , curl_socket_t curlfd , curlsocktype purpose )
const curl_sockopt_callback = Ptr{Cvoid}

mutable struct curl_sockaddr
    family::Cint
    socktype::Cint
    protocol::Cint
    addrlen::Cuint
    addr::sockaddr
    curl_sockaddr() = new()
end

# typedef curl_socket_t ( * curl_opensocket_callback ) ( void * clientp , curlsocktype purpose , struct curl_sockaddr * address )
const curl_opensocket_callback = Ptr{Cvoid}

# typedef int ( * curl_closesocket_callback ) ( void * clientp , curl_socket_t item )
const curl_closesocket_callback = Ptr{Cvoid}

const curlioerr = UInt32
const CURLIOE_OK = 0 % UInt32
const CURLIOE_UNKNOWNCMD = 1 % UInt32
const CURLIOE_FAILRESTART = 2 % UInt32
const CURLIOE_LAST = 3 % UInt32

const curliocmd = UInt32
const CURLIOCMD_NOP = 0 % UInt32
const CURLIOCMD_RESTARTREAD = 1 % UInt32
const CURLIOCMD_LAST = 2 % UInt32

# typedef curlioerr ( * curl_ioctl_callback ) ( CURL * handle , int cmd , void * clientp )
const curl_ioctl_callback = Ptr{Cvoid}

# typedef void * ( * curl_malloc_callback ) ( size_t size )
const curl_malloc_callback = Ptr{Cvoid}

# typedef void ( * curl_free_callback ) ( void * ptr )
const curl_free_callback = Ptr{Cvoid}

# typedef void * ( * curl_realloc_callback ) ( void * ptr , size_t size )
const curl_realloc_callback = Ptr{Cvoid}

# typedef char * ( * curl_strdup_callback ) ( const char * str )
const curl_strdup_callback = Ptr{Cvoid}

# typedef void * ( * curl_calloc_callback ) ( size_t nmemb , size_t size )
const curl_calloc_callback = Ptr{Cvoid}

const curl_infotype = UInt32
const CURLINFO_TEXT = 0 % UInt32
const CURLINFO_HEADER_IN = 1 % UInt32
const CURLINFO_HEADER_OUT = 2 % UInt32
const CURLINFO_DATA_IN = 3 % UInt32
const CURLINFO_DATA_OUT = 4 % UInt32
const CURLINFO_SSL_DATA_IN = 5 % UInt32
const CURLINFO_SSL_DATA_OUT = 6 % UInt32
const CURLINFO_END = 7 % UInt32

# typedef int ( * curl_debug_callback ) ( CURL * handle , /* the handle/transfer this concerns */ curl_infotype type , /* what kind of data */ char * data , /* points to the data */ size_t size , /* size of the data pointed to */ void * userptr )
const curl_debug_callback = Ptr{Cvoid}

const CURLcode = UInt32
const CURLE_OK = 0 % UInt32
const CURLE_UNSUPPORTED_PROTOCOL = 1 % UInt32
const CURLE_FAILED_INIT = 2 % UInt32
const CURLE_URL_MALFORMAT = 3 % UInt32
const CURLE_NOT_BUILT_IN = 4 % UInt32
const CURLE_COULDNT_RESOLVE_PROXY = 5 % UInt32
const CURLE_COULDNT_RESOLVE_HOST = 6 % UInt32
const CURLE_COULDNT_CONNECT = 7 % UInt32
const CURLE_WEIRD_SERVER_REPLY = 8 % UInt32
const CURLE_REMOTE_ACCESS_DENIED = 9 % UInt32
const CURLE_FTP_ACCEPT_FAILED = 10 % UInt32
const CURLE_FTP_WEIRD_PASS_REPLY = 11 % UInt32
const CURLE_FTP_ACCEPT_TIMEOUT = 12 % UInt32
const CURLE_FTP_WEIRD_PASV_REPLY = 13 % UInt32
const CURLE_FTP_WEIRD_227_FORMAT = 14 % UInt32
const CURLE_FTP_CANT_GET_HOST = 15 % UInt32
const CURLE_HTTP2 = 16 % UInt32
const CURLE_FTP_COULDNT_SET_TYPE = 17 % UInt32
const CURLE_PARTIAL_FILE = 18 % UInt32
const CURLE_FTP_COULDNT_RETR_FILE = 19 % UInt32
const CURLE_OBSOLETE20 = 20 % UInt32
const CURLE_QUOTE_ERROR = 21 % UInt32
const CURLE_HTTP_RETURNED_ERROR = 22 % UInt32
const CURLE_WRITE_ERROR = 23 % UInt32
const CURLE_OBSOLETE24 = 24 % UInt32
const CURLE_UPLOAD_FAILED = 25 % UInt32
const CURLE_READ_ERROR = 26 % UInt32
const CURLE_OUT_OF_MEMORY = 27 % UInt32
const CURLE_OPERATION_TIMEDOUT = 28 % UInt32
const CURLE_OBSOLETE29 = 29 % UInt32
const CURLE_FTP_PORT_FAILED = 30 % UInt32
const CURLE_FTP_COULDNT_USE_REST = 31 % UInt32
const CURLE_OBSOLETE32 = 32 % UInt32
const CURLE_RANGE_ERROR = 33 % UInt32
const CURLE_HTTP_POST_ERROR = 34 % UInt32
const CURLE_SSL_CONNECT_ERROR = 35 % UInt32
const CURLE_BAD_DOWNLOAD_RESUME = 36 % UInt32
const CURLE_FILE_COULDNT_READ_FILE = 37 % UInt32
const CURLE_LDAP_CANNOT_BIND = 38 % UInt32
const CURLE_LDAP_SEARCH_FAILED = 39 % UInt32
const CURLE_OBSOLETE40 = 40 % UInt32
const CURLE_FUNCTION_NOT_FOUND = 41 % UInt32
const CURLE_ABORTED_BY_CALLBACK = 42 % UInt32
const CURLE_BAD_FUNCTION_ARGUMENT = 43 % UInt32
const CURLE_OBSOLETE44 = 44 % UInt32
const CURLE_INTERFACE_FAILED = 45 % UInt32
const CURLE_OBSOLETE46 = 46 % UInt32
const CURLE_TOO_MANY_REDIRECTS = 47 % UInt32
const CURLE_UNKNOWN_OPTION = 48 % UInt32
const CURLE_TELNET_OPTION_SYNTAX = 49 % UInt32
const CURLE_OBSOLETE50 = 50 % UInt32
const CURLE_OBSOLETE51 = 51 % UInt32
const CURLE_GOT_NOTHING = 52 % UInt32
const CURLE_SSL_ENGINE_NOTFOUND = 53 % UInt32
const CURLE_SSL_ENGINE_SETFAILED = 54 % UInt32
const CURLE_SEND_ERROR = 55 % UInt32
const CURLE_RECV_ERROR = 56 % UInt32
const CURLE_OBSOLETE57 = 57 % UInt32
const CURLE_SSL_CERTPROBLEM = 58 % UInt32
const CURLE_SSL_CIPHER = 59 % UInt32
const CURLE_PEER_FAILED_VERIFICATION = 60 % UInt32
const CURLE_BAD_CONTENT_ENCODING = 61 % UInt32
const CURLE_LDAP_INVALID_URL = 62 % UInt32
const CURLE_FILESIZE_EXCEEDED = 63 % UInt32
const CURLE_USE_SSL_FAILED = 64 % UInt32
const CURLE_SEND_FAIL_REWIND = 65 % UInt32
const CURLE_SSL_ENGINE_INITFAILED = 66 % UInt32
const CURLE_LOGIN_DENIED = 67 % UInt32
const CURLE_TFTP_NOTFOUND = 68 % UInt32
const CURLE_TFTP_PERM = 69 % UInt32
const CURLE_REMOTE_DISK_FULL = 70 % UInt32
const CURLE_TFTP_ILLEGAL = 71 % UInt32
const CURLE_TFTP_UNKNOWNID = 72 % UInt32
const CURLE_REMOTE_FILE_EXISTS = 73 % UInt32
const CURLE_TFTP_NOSUCHUSER = 74 % UInt32
const CURLE_CONV_FAILED = 75 % UInt32
const CURLE_CONV_REQD = 76 % UInt32
const CURLE_SSL_CACERT_BADFILE = 77 % UInt32
const CURLE_REMOTE_FILE_NOT_FOUND = 78 % UInt32
const CURLE_SSH = 79 % UInt32
const CURLE_SSL_SHUTDOWN_FAILED = 80 % UInt32
const CURLE_AGAIN = 81 % UInt32
const CURLE_SSL_CRL_BADFILE = 82 % UInt32
const CURLE_SSL_ISSUER_ERROR = 83 % UInt32
const CURLE_FTP_PRET_FAILED = 84 % UInt32
const CURLE_RTSP_CSEQ_ERROR = 85 % UInt32
const CURLE_RTSP_SESSION_ERROR = 86 % UInt32
const CURLE_FTP_BAD_FILE_LIST = 87 % UInt32
const CURLE_CHUNK_FAILED = 88 % UInt32
const CURLE_NO_CONNECTION_AVAILABLE = 89 % UInt32
const CURLE_SSL_PINNEDPUBKEYNOTMATCH = 90 % UInt32
const CURLE_SSL_INVALIDCERTSTATUS = 91 % UInt32
const CURLE_HTTP2_STREAM = 92 % UInt32
const CURLE_RECURSIVE_API_CALL = 93 % UInt32
const CURLE_AUTH_ERROR = 94 % UInt32
const CURLE_HTTP3 = 95 % UInt32
const CURLE_QUIC_CONNECT_ERROR = 96 % UInt32
const CURLE_PROXY = 97 % UInt32
const CURL_LAST = 98 % UInt32

const CURLproxycode = UInt32
const CURLPX_OK = 0 % UInt32
const CURLPX_BAD_ADDRESS_TYPE = 1 % UInt32
const CURLPX_BAD_VERSION = 2 % UInt32
const CURLPX_CLOSED = 3 % UInt32
const CURLPX_GSSAPI = 4 % UInt32
const CURLPX_GSSAPI_PERMSG = 5 % UInt32
const CURLPX_GSSAPI_PROTECTION = 6 % UInt32
const CURLPX_IDENTD = 7 % UInt32
const CURLPX_IDENTD_DIFFER = 8 % UInt32
const CURLPX_LONG_HOSTNAME = 9 % UInt32
const CURLPX_LONG_PASSWD = 10 % UInt32
const CURLPX_LONG_USER = 11 % UInt32
const CURLPX_NO_AUTH = 12 % UInt32
const CURLPX_RECV_ADDRESS = 13 % UInt32
const CURLPX_RECV_AUTH = 14 % UInt32
const CURLPX_RECV_CONNECT = 15 % UInt32
const CURLPX_RECV_REQACK = 16 % UInt32
const CURLPX_REPLY_ADDRESS_TYPE_NOT_SUPPORTED = 17 % UInt32
const CURLPX_REPLY_COMMAND_NOT_SUPPORTED = 18 % UInt32
const CURLPX_REPLY_CONNECTION_REFUSED = 19 % UInt32
const CURLPX_REPLY_GENERAL_SERVER_FAILURE = 20 % UInt32
const CURLPX_REPLY_HOST_UNREACHABLE = 21 % UInt32
const CURLPX_REPLY_NETWORK_UNREACHABLE = 22 % UInt32
const CURLPX_REPLY_NOT_ALLOWED = 23 % UInt32
const CURLPX_REPLY_TTL_EXPIRED = 24 % UInt32
const CURLPX_REPLY_UNASSIGNED = 25 % UInt32
const CURLPX_REQUEST_FAILED = 26 % UInt32
const CURLPX_RESOLVE_HOST = 27 % UInt32
const CURLPX_SEND_AUTH = 28 % UInt32
const CURLPX_SEND_CONNECT = 29 % UInt32
const CURLPX_SEND_REQUEST = 30 % UInt32
const CURLPX_UNKNOWN_FAIL = 31 % UInt32
const CURLPX_UNKNOWN_MODE = 32 % UInt32
const CURLPX_USER_REJECTED = 33 % UInt32
const CURLPX_LAST = 34 % UInt32

# typedef CURLcode ( * curl_conv_callback ) ( char * buffer , size_t length )
const curl_conv_callback = Ptr{Cvoid}

# typedef CURLcode ( * curl_ssl_ctx_callback ) ( CURL * curl , /* easy handle */ void * ssl_ctx , /* actually an OpenSSL
#                                                            or WolfSSL SSL_CTX,
#                                                            or an mbedTLS
#                                                          mbedtls_ssl_config */ void * userptr )
const curl_ssl_ctx_callback = Ptr{Cvoid}

const curl_proxytype = UInt32
const CURLPROXY_HTTP = 0 % UInt32
const CURLPROXY_HTTP_1_0 = 1 % UInt32
const CURLPROXY_HTTPS = 2 % UInt32
const CURLPROXY_SOCKS4 = 4 % UInt32
const CURLPROXY_SOCKS5 = 5 % UInt32
const CURLPROXY_SOCKS4A = 6 % UInt32
const CURLPROXY_SOCKS5_HOSTNAME = 7 % UInt32

const curl_khtype = UInt32
const CURLKHTYPE_UNKNOWN = 0 % UInt32
const CURLKHTYPE_RSA1 = 1 % UInt32
const CURLKHTYPE_RSA = 2 % UInt32
const CURLKHTYPE_DSS = 3 % UInt32
const CURLKHTYPE_ECDSA = 4 % UInt32
const CURLKHTYPE_ED25519 = 5 % UInt32

mutable struct curl_khkey
    key::Ptr{Cchar}
    len::Csize_t
    keytype::curl_khtype
    curl_khkey() = new()
end

const curl_khstat = UInt32
const CURLKHSTAT_FINE_ADD_TO_FILE = 0 % UInt32
const CURLKHSTAT_FINE = 1 % UInt32
const CURLKHSTAT_REJECT = 2 % UInt32
const CURLKHSTAT_DEFER = 3 % UInt32
const CURLKHSTAT_FINE_REPLACE = 4 % UInt32
const CURLKHSTAT_LAST = 5 % UInt32

const curl_khmatch = UInt32
const CURLKHMATCH_OK = 0 % UInt32
const CURLKHMATCH_MISMATCH = 1 % UInt32
const CURLKHMATCH_MISSING = 2 % UInt32
const CURLKHMATCH_LAST = 3 % UInt32

# typedef int ( * curl_sshkeycallback ) ( CURL * easy , /* easy handle */ const struct curl_khkey * knownkey , /* known */ const struct curl_khkey * foundkey , /* found */ enum curl_khmatch , /* libcurl's view on the keys */ void * clientp )
const curl_sshkeycallback = Ptr{Cvoid}

const curl_ftpccc = UInt32
const CURLFTPSSL_CCC_NONE = 0 % UInt32
const CURLFTPSSL_CCC_PASSIVE = 1 % UInt32
const CURLFTPSSL_CCC_ACTIVE = 2 % UInt32
const CURLFTPSSL_CCC_LAST = 3 % UInt32

const curl_ftpauth = UInt32
const CURLFTPAUTH_DEFAULT = 0 % UInt32
const CURLFTPAUTH_SSL = 1 % UInt32
const CURLFTPAUTH_TLS = 2 % UInt32
const CURLFTPAUTH_LAST = 3 % UInt32

const curl_ftpcreatedir = UInt32
const CURLFTP_CREATE_DIR_NONE = 0 % UInt32
const CURLFTP_CREATE_DIR = 1 % UInt32
const CURLFTP_CREATE_DIR_RETRY = 2 % UInt32
const CURLFTP_CREATE_DIR_LAST = 3 % UInt32

const curl_ftpmethod = UInt32
const CURLFTPMETHOD_DEFAULT = 0 % UInt32
const CURLFTPMETHOD_MULTICWD = 1 % UInt32
const CURLFTPMETHOD_NOCWD = 2 % UInt32
const CURLFTPMETHOD_SINGLECWD = 3 % UInt32
const CURLFTPMETHOD_LAST = 4 % UInt32

const CURLoption = UInt32
const CURLOPT_WRITEDATA = 10001 % UInt32
const CURLOPT_URL = 10002 % UInt32
const CURLOPT_PORT = 3 % UInt32
const CURLOPT_PROXY = 10004 % UInt32
const CURLOPT_USERPWD = 10005 % UInt32
const CURLOPT_PROXYUSERPWD = 10006 % UInt32
const CURLOPT_RANGE = 10007 % UInt32
const CURLOPT_READDATA = 10009 % UInt32
const CURLOPT_ERRORBUFFER = 10010 % UInt32
const CURLOPT_WRITEFUNCTION = 20011 % UInt32
const CURLOPT_READFUNCTION = 20012 % UInt32
const CURLOPT_TIMEOUT = 13 % UInt32
const CURLOPT_INFILESIZE = 14 % UInt32
const CURLOPT_POSTFIELDS = 10015 % UInt32
const CURLOPT_REFERER = 10016 % UInt32
const CURLOPT_FTPPORT = 10017 % UInt32
const CURLOPT_USERAGENT = 10018 % UInt32
const CURLOPT_LOW_SPEED_LIMIT = 19 % UInt32
const CURLOPT_LOW_SPEED_TIME = 20 % UInt32
const CURLOPT_RESUME_FROM = 21 % UInt32
const CURLOPT_COOKIE = 10022 % UInt32
const CURLOPT_HTTPHEADER = 10023 % UInt32
const CURLOPT_HTTPPOST = 10024 % UInt32
const CURLOPT_SSLCERT = 10025 % UInt32
const CURLOPT_KEYPASSWD = 10026 % UInt32
const CURLOPT_CRLF = 27 % UInt32
const CURLOPT_QUOTE = 10028 % UInt32
const CURLOPT_HEADERDATA = 10029 % UInt32
const CURLOPT_COOKIEFILE = 10031 % UInt32
const CURLOPT_SSLVERSION = 32 % UInt32
const CURLOPT_TIMECONDITION = 33 % UInt32
const CURLOPT_TIMEVALUE = 34 % UInt32
const CURLOPT_CUSTOMREQUEST = 10036 % UInt32
const CURLOPT_STDERR = 10037 % UInt32
const CURLOPT_POSTQUOTE = 10039 % UInt32
const CURLOPT_OBSOLETE40 = 10040 % UInt32
const CURLOPT_VERBOSE = 41 % UInt32
const CURLOPT_HEADER = 42 % UInt32
const CURLOPT_NOPROGRESS = 43 % UInt32
const CURLOPT_NOBODY = 44 % UInt32
const CURLOPT_FAILONERROR = 45 % UInt32
const CURLOPT_UPLOAD = 46 % UInt32
const CURLOPT_POST = 47 % UInt32
const CURLOPT_DIRLISTONLY = 48 % UInt32
const CURLOPT_APPEND = 50 % UInt32
const CURLOPT_NETRC = 51 % UInt32
const CURLOPT_FOLLOWLOCATION = 52 % UInt32
const CURLOPT_TRANSFERTEXT = 53 % UInt32
const CURLOPT_PUT = 54 % UInt32
const CURLOPT_PROGRESSFUNCTION = 20056 % UInt32
const CURLOPT_XFERINFODATA = 10057 % UInt32
const CURLOPT_AUTOREFERER = 58 % UInt32
const CURLOPT_PROXYPORT = 59 % UInt32
const CURLOPT_POSTFIELDSIZE = 60 % UInt32
const CURLOPT_HTTPPROXYTUNNEL = 61 % UInt32
const CURLOPT_INTERFACE = 10062 % UInt32
const CURLOPT_KRBLEVEL = 10063 % UInt32
const CURLOPT_SSL_VERIFYPEER = 64 % UInt32
const CURLOPT_CAINFO = 10065 % UInt32
const CURLOPT_MAXREDIRS = 68 % UInt32
const CURLOPT_FILETIME = 69 % UInt32
const CURLOPT_TELNETOPTIONS = 10070 % UInt32
const CURLOPT_MAXCONNECTS = 71 % UInt32
const CURLOPT_OBSOLETE72 = 72 % UInt32
const CURLOPT_FRESH_CONNECT = 74 % UInt32
const CURLOPT_FORBID_REUSE = 75 % UInt32
const CURLOPT_RANDOM_FILE = 10076 % UInt32
const CURLOPT_EGDSOCKET = 10077 % UInt32
const CURLOPT_CONNECTTIMEOUT = 78 % UInt32
const CURLOPT_HEADERFUNCTION = 20079 % UInt32
const CURLOPT_HTTPGET = 80 % UInt32
const CURLOPT_SSL_VERIFYHOST = 81 % UInt32
const CURLOPT_COOKIEJAR = 10082 % UInt32
const CURLOPT_SSL_CIPHER_LIST = 10083 % UInt32
const CURLOPT_HTTP_VERSION = 84 % UInt32
const CURLOPT_FTP_USE_EPSV = 85 % UInt32
const CURLOPT_SSLCERTTYPE = 10086 % UInt32
const CURLOPT_SSLKEY = 10087 % UInt32
const CURLOPT_SSLKEYTYPE = 10088 % UInt32
const CURLOPT_SSLENGINE = 10089 % UInt32
const CURLOPT_SSLENGINE_DEFAULT = 90 % UInt32
const CURLOPT_DNS_USE_GLOBAL_CACHE = 91 % UInt32
const CURLOPT_DNS_CACHE_TIMEOUT = 92 % UInt32
const CURLOPT_PREQUOTE = 10093 % UInt32
const CURLOPT_DEBUGFUNCTION = 20094 % UInt32
const CURLOPT_DEBUGDATA = 10095 % UInt32
const CURLOPT_COOKIESESSION = 96 % UInt32
const CURLOPT_CAPATH = 10097 % UInt32
const CURLOPT_BUFFERSIZE = 98 % UInt32
const CURLOPT_NOSIGNAL = 99 % UInt32
const CURLOPT_SHARE = 10100 % UInt32
const CURLOPT_PROXYTYPE = 101 % UInt32
const CURLOPT_ACCEPT_ENCODING = 10102 % UInt32
const CURLOPT_PRIVATE = 10103 % UInt32
const CURLOPT_HTTP200ALIASES = 10104 % UInt32
const CURLOPT_UNRESTRICTED_AUTH = 105 % UInt32
const CURLOPT_FTP_USE_EPRT = 106 % UInt32
const CURLOPT_HTTPAUTH = 107 % UInt32
const CURLOPT_SSL_CTX_FUNCTION = 20108 % UInt32
const CURLOPT_SSL_CTX_DATA = 10109 % UInt32
const CURLOPT_FTP_CREATE_MISSING_DIRS = 110 % UInt32
const CURLOPT_PROXYAUTH = 111 % UInt32
const CURLOPT_FTP_RESPONSE_TIMEOUT = 112 % UInt32
const CURLOPT_IPRESOLVE = 113 % UInt32
const CURLOPT_MAXFILESIZE = 114 % UInt32
const CURLOPT_INFILESIZE_LARGE = 30115 % UInt32
const CURLOPT_RESUME_FROM_LARGE = 30116 % UInt32
const CURLOPT_MAXFILESIZE_LARGE = 30117 % UInt32
const CURLOPT_NETRC_FILE = 10118 % UInt32
const CURLOPT_USE_SSL = 119 % UInt32
const CURLOPT_POSTFIELDSIZE_LARGE = 30120 % UInt32
const CURLOPT_TCP_NODELAY = 121 % UInt32
const CURLOPT_FTPSSLAUTH = 129 % UInt32
const CURLOPT_IOCTLFUNCTION = 20130 % UInt32
const CURLOPT_IOCTLDATA = 10131 % UInt32
const CURLOPT_FTP_ACCOUNT = 10134 % UInt32
const CURLOPT_COOKIELIST = 10135 % UInt32
const CURLOPT_IGNORE_CONTENT_LENGTH = 136 % UInt32
const CURLOPT_FTP_SKIP_PASV_IP = 137 % UInt32
const CURLOPT_FTP_FILEMETHOD = 138 % UInt32
const CURLOPT_LOCALPORT = 139 % UInt32
const CURLOPT_LOCALPORTRANGE = 140 % UInt32
const CURLOPT_CONNECT_ONLY = 141 % UInt32
const CURLOPT_CONV_FROM_NETWORK_FUNCTION = 20142 % UInt32
const CURLOPT_CONV_TO_NETWORK_FUNCTION = 20143 % UInt32
const CURLOPT_CONV_FROM_UTF8_FUNCTION = 20144 % UInt32
const CURLOPT_MAX_SEND_SPEED_LARGE = 30145 % UInt32
const CURLOPT_MAX_RECV_SPEED_LARGE = 30146 % UInt32
const CURLOPT_FTP_ALTERNATIVE_TO_USER = 10147 % UInt32
const CURLOPT_SOCKOPTFUNCTION = 20148 % UInt32
const CURLOPT_SOCKOPTDATA = 10149 % UInt32
const CURLOPT_SSL_SESSIONID_CACHE = 150 % UInt32
const CURLOPT_SSH_AUTH_TYPES = 151 % UInt32
const CURLOPT_SSH_PUBLIC_KEYFILE = 10152 % UInt32
const CURLOPT_SSH_PRIVATE_KEYFILE = 10153 % UInt32
const CURLOPT_FTP_SSL_CCC = 154 % UInt32
const CURLOPT_TIMEOUT_MS = 155 % UInt32
const CURLOPT_CONNECTTIMEOUT_MS = 156 % UInt32
const CURLOPT_HTTP_TRANSFER_DECODING = 157 % UInt32
const CURLOPT_HTTP_CONTENT_DECODING = 158 % UInt32
const CURLOPT_NEW_FILE_PERMS = 159 % UInt32
const CURLOPT_NEW_DIRECTORY_PERMS = 160 % UInt32
const CURLOPT_POSTREDIR = 161 % UInt32
const CURLOPT_SSH_HOST_PUBLIC_KEY_MD5 = 10162 % UInt32
const CURLOPT_OPENSOCKETFUNCTION = 20163 % UInt32
const CURLOPT_OPENSOCKETDATA = 10164 % UInt32
const CURLOPT_COPYPOSTFIELDS = 10165 % UInt32
const CURLOPT_PROXY_TRANSFER_MODE = 166 % UInt32
const CURLOPT_SEEKFUNCTION = 20167 % UInt32
const CURLOPT_SEEKDATA = 10168 % UInt32
const CURLOPT_CRLFILE = 10169 % UInt32
const CURLOPT_ISSUERCERT = 10170 % UInt32
const CURLOPT_ADDRESS_SCOPE = 171 % UInt32
const CURLOPT_CERTINFO = 172 % UInt32
const CURLOPT_USERNAME = 10173 % UInt32
const CURLOPT_PASSWORD = 10174 % UInt32
const CURLOPT_PROXYUSERNAME = 10175 % UInt32
const CURLOPT_PROXYPASSWORD = 10176 % UInt32
const CURLOPT_NOPROXY = 10177 % UInt32
const CURLOPT_TFTP_BLKSIZE = 178 % UInt32
const CURLOPT_SOCKS5_GSSAPI_SERVICE = 10179 % UInt32
const CURLOPT_SOCKS5_GSSAPI_NEC = 180 % UInt32
const CURLOPT_PROTOCOLS = 181 % UInt32
const CURLOPT_REDIR_PROTOCOLS = 182 % UInt32
const CURLOPT_SSH_KNOWNHOSTS = 10183 % UInt32
const CURLOPT_SSH_KEYFUNCTION = 20184 % UInt32
const CURLOPT_SSH_KEYDATA = 10185 % UInt32
const CURLOPT_MAIL_FROM = 10186 % UInt32
const CURLOPT_MAIL_RCPT = 10187 % UInt32
const CURLOPT_FTP_USE_PRET = 188 % UInt32
const CURLOPT_RTSP_REQUEST = 189 % UInt32
const CURLOPT_RTSP_SESSION_ID = 10190 % UInt32
const CURLOPT_RTSP_STREAM_URI = 10191 % UInt32
const CURLOPT_RTSP_TRANSPORT = 10192 % UInt32
const CURLOPT_RTSP_CLIENT_CSEQ = 193 % UInt32
const CURLOPT_RTSP_SERVER_CSEQ = 194 % UInt32
const CURLOPT_INTERLEAVEDATA = 10195 % UInt32
const CURLOPT_INTERLEAVEFUNCTION = 20196 % UInt32
const CURLOPT_WILDCARDMATCH = 197 % UInt32
const CURLOPT_CHUNK_BGN_FUNCTION = 20198 % UInt32
const CURLOPT_CHUNK_END_FUNCTION = 20199 % UInt32
const CURLOPT_FNMATCH_FUNCTION = 20200 % UInt32
const CURLOPT_CHUNK_DATA = 10201 % UInt32
const CURLOPT_FNMATCH_DATA = 10202 % UInt32
const CURLOPT_RESOLVE = 10203 % UInt32
const CURLOPT_TLSAUTH_USERNAME = 10204 % UInt32
const CURLOPT_TLSAUTH_PASSWORD = 10205 % UInt32
const CURLOPT_TLSAUTH_TYPE = 10206 % UInt32
const CURLOPT_TRANSFER_ENCODING = 207 % UInt32
const CURLOPT_CLOSESOCKETFUNCTION = 20208 % UInt32
const CURLOPT_CLOSESOCKETDATA = 10209 % UInt32
const CURLOPT_GSSAPI_DELEGATION = 210 % UInt32
const CURLOPT_DNS_SERVERS = 10211 % UInt32
const CURLOPT_ACCEPTTIMEOUT_MS = 212 % UInt32
const CURLOPT_TCP_KEEPALIVE = 213 % UInt32
const CURLOPT_TCP_KEEPIDLE = 214 % UInt32
const CURLOPT_TCP_KEEPINTVL = 215 % UInt32
const CURLOPT_SSL_OPTIONS = 216 % UInt32
const CURLOPT_MAIL_AUTH = 10217 % UInt32
const CURLOPT_SASL_IR = 218 % UInt32
const CURLOPT_XFERINFOFUNCTION = 20219 % UInt32
const CURLOPT_XOAUTH2_BEARER = 10220 % UInt32
const CURLOPT_DNS_INTERFACE = 10221 % UInt32
const CURLOPT_DNS_LOCAL_IP4 = 10222 % UInt32
const CURLOPT_DNS_LOCAL_IP6 = 10223 % UInt32
const CURLOPT_LOGIN_OPTIONS = 10224 % UInt32
const CURLOPT_SSL_ENABLE_NPN = 225 % UInt32
const CURLOPT_SSL_ENABLE_ALPN = 226 % UInt32
const CURLOPT_EXPECT_100_TIMEOUT_MS = 227 % UInt32
const CURLOPT_PROXYHEADER = 10228 % UInt32
const CURLOPT_HEADEROPT = 229 % UInt32
const CURLOPT_PINNEDPUBLICKEY = 10230 % UInt32
const CURLOPT_UNIX_SOCKET_PATH = 10231 % UInt32
const CURLOPT_SSL_VERIFYSTATUS = 232 % UInt32
const CURLOPT_SSL_FALSESTART = 233 % UInt32
const CURLOPT_PATH_AS_IS = 234 % UInt32
const CURLOPT_PROXY_SERVICE_NAME = 10235 % UInt32
const CURLOPT_SERVICE_NAME = 10236 % UInt32
const CURLOPT_PIPEWAIT = 237 % UInt32
const CURLOPT_DEFAULT_PROTOCOL = 10238 % UInt32
const CURLOPT_STREAM_WEIGHT = 239 % UInt32
const CURLOPT_STREAM_DEPENDS = 10240 % UInt32
const CURLOPT_STREAM_DEPENDS_E = 10241 % UInt32
const CURLOPT_TFTP_NO_OPTIONS = 242 % UInt32
const CURLOPT_CONNECT_TO = 10243 % UInt32
const CURLOPT_TCP_FASTOPEN = 244 % UInt32
const CURLOPT_KEEP_SENDING_ON_ERROR = 245 % UInt32
const CURLOPT_PROXY_CAINFO = 10246 % UInt32
const CURLOPT_PROXY_CAPATH = 10247 % UInt32
const CURLOPT_PROXY_SSL_VERIFYPEER = 248 % UInt32
const CURLOPT_PROXY_SSL_VERIFYHOST = 249 % UInt32
const CURLOPT_PROXY_SSLVERSION = 250 % UInt32
const CURLOPT_PROXY_TLSAUTH_USERNAME = 10251 % UInt32
const CURLOPT_PROXY_TLSAUTH_PASSWORD = 10252 % UInt32
const CURLOPT_PROXY_TLSAUTH_TYPE = 10253 % UInt32
const CURLOPT_PROXY_SSLCERT = 10254 % UInt32
const CURLOPT_PROXY_SSLCERTTYPE = 10255 % UInt32
const CURLOPT_PROXY_SSLKEY = 10256 % UInt32
const CURLOPT_PROXY_SSLKEYTYPE = 10257 % UInt32
const CURLOPT_PROXY_KEYPASSWD = 10258 % UInt32
const CURLOPT_PROXY_SSL_CIPHER_LIST = 10259 % UInt32
const CURLOPT_PROXY_CRLFILE = 10260 % UInt32
const CURLOPT_PROXY_SSL_OPTIONS = 261 % UInt32
const CURLOPT_PRE_PROXY = 10262 % UInt32
const CURLOPT_PROXY_PINNEDPUBLICKEY = 10263 % UInt32
const CURLOPT_ABSTRACT_UNIX_SOCKET = 10264 % UInt32
const CURLOPT_SUPPRESS_CONNECT_HEADERS = 265 % UInt32
const CURLOPT_REQUEST_TARGET = 10266 % UInt32
const CURLOPT_SOCKS5_AUTH = 267 % UInt32
const CURLOPT_SSH_COMPRESSION = 268 % UInt32
const CURLOPT_MIMEPOST = 10269 % UInt32
const CURLOPT_TIMEVALUE_LARGE = 30270 % UInt32
const CURLOPT_HAPPY_EYEBALLS_TIMEOUT_MS = 271 % UInt32
const CURLOPT_RESOLVER_START_FUNCTION = 20272 % UInt32
const CURLOPT_RESOLVER_START_DATA = 10273 % UInt32
const CURLOPT_HAPROXYPROTOCOL = 274 % UInt32
const CURLOPT_DNS_SHUFFLE_ADDRESSES = 275 % UInt32
const CURLOPT_TLS13_CIPHERS = 10276 % UInt32
const CURLOPT_PROXY_TLS13_CIPHERS = 10277 % UInt32
const CURLOPT_DISALLOW_USERNAME_IN_URL = 278 % UInt32
const CURLOPT_DOH_URL = 10279 % UInt32
const CURLOPT_UPLOAD_BUFFERSIZE = 280 % UInt32
const CURLOPT_UPKEEP_INTERVAL_MS = 281 % UInt32
const CURLOPT_CURLU = 10282 % UInt32
const CURLOPT_TRAILERFUNCTION = 20283 % UInt32
const CURLOPT_TRAILERDATA = 10284 % UInt32
const CURLOPT_HTTP09_ALLOWED = 285 % UInt32
const CURLOPT_ALTSVC_CTRL = 286 % UInt32
const CURLOPT_ALTSVC = 10287 % UInt32
const CURLOPT_MAXAGE_CONN = 288 % UInt32
const CURLOPT_SASL_AUTHZID = 10289 % UInt32
const CURLOPT_MAIL_RCPT_ALLLOWFAILS = 290 % UInt32
const CURLOPT_SSLCERT_BLOB = 40291 % UInt32
const CURLOPT_SSLKEY_BLOB = 40292 % UInt32
const CURLOPT_PROXY_SSLCERT_BLOB = 40293 % UInt32
const CURLOPT_PROXY_SSLKEY_BLOB = 40294 % UInt32
const CURLOPT_ISSUERCERT_BLOB = 40295 % UInt32
const CURLOPT_PROXY_ISSUERCERT = 10296 % UInt32
const CURLOPT_PROXY_ISSUERCERT_BLOB = 40297 % UInt32
const CURLOPT_SSL_EC_CURVES = 10298 % UInt32
const CURLOPT_LASTENTRY = 10299 % UInt32

const __JL_Ctag_33 = UInt32
const CURL_HTTP_VERSION_NONE = 0 % UInt32
const CURL_HTTP_VERSION_1_0 = 1 % UInt32
const CURL_HTTP_VERSION_1_1 = 2 % UInt32
const CURL_HTTP_VERSION_2_0 = 3 % UInt32
const CURL_HTTP_VERSION_2TLS = 4 % UInt32
const CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE = 5 % UInt32
const CURL_HTTP_VERSION_3 = 30 % UInt32
const CURL_HTTP_VERSION_LAST = 31 % UInt32

const __JL_Ctag_34 = UInt32
const CURL_RTSPREQ_NONE = 0 % UInt32
const CURL_RTSPREQ_OPTIONS = 1 % UInt32
const CURL_RTSPREQ_DESCRIBE = 2 % UInt32
const CURL_RTSPREQ_ANNOUNCE = 3 % UInt32
const CURL_RTSPREQ_SETUP = 4 % UInt32
const CURL_RTSPREQ_PLAY = 5 % UInt32
const CURL_RTSPREQ_PAUSE = 6 % UInt32
const CURL_RTSPREQ_TEARDOWN = 7 % UInt32
const CURL_RTSPREQ_GET_PARAMETER = 8 % UInt32
const CURL_RTSPREQ_SET_PARAMETER = 9 % UInt32
const CURL_RTSPREQ_RECORD = 10 % UInt32
const CURL_RTSPREQ_RECEIVE = 11 % UInt32
const CURL_RTSPREQ_LAST = 12 % UInt32

const CURL_NETRC_OPTION = UInt32
const CURL_NETRC_IGNORED = 0 % UInt32
const CURL_NETRC_OPTIONAL = 1 % UInt32
const CURL_NETRC_REQUIRED = 2 % UInt32
const CURL_NETRC_LAST = 3 % UInt32

const __JL_Ctag_35 = UInt32
const CURL_SSLVERSION_DEFAULT = 0 % UInt32
const CURL_SSLVERSION_TLSv1 = 1 % UInt32
const CURL_SSLVERSION_SSLv2 = 2 % UInt32
const CURL_SSLVERSION_SSLv3 = 3 % UInt32
const CURL_SSLVERSION_TLSv1_0 = 4 % UInt32
const CURL_SSLVERSION_TLSv1_1 = 5 % UInt32
const CURL_SSLVERSION_TLSv1_2 = 6 % UInt32
const CURL_SSLVERSION_TLSv1_3 = 7 % UInt32
const CURL_SSLVERSION_LAST = 8 % UInt32

const __JL_Ctag_36 = UInt32
const CURL_SSLVERSION_MAX_NONE = 0 % UInt32
const CURL_SSLVERSION_MAX_DEFAULT = 65536 % UInt32
const CURL_SSLVERSION_MAX_TLSv1_0 = 262144 % UInt32
const CURL_SSLVERSION_MAX_TLSv1_1 = 327680 % UInt32
const CURL_SSLVERSION_MAX_TLSv1_2 = 393216 % UInt32
const CURL_SSLVERSION_MAX_TLSv1_3 = 458752 % UInt32
const CURL_SSLVERSION_MAX_LAST = 524288 % UInt32

const CURL_TLSAUTH = UInt32
const CURL_TLSAUTH_NONE = 0 % UInt32
const CURL_TLSAUTH_SRP = 1 % UInt32
const CURL_TLSAUTH_LAST = 2 % UInt32

const curl_TimeCond = UInt32
const CURL_TIMECOND_NONE = 0 % UInt32
const CURL_TIMECOND_IFMODSINCE = 1 % UInt32
const CURL_TIMECOND_IFUNMODSINCE = 2 % UInt32
const CURL_TIMECOND_LASTMOD = 3 % UInt32
const CURL_TIMECOND_LAST = 4 % UInt32

function curl_strequal(s1, s2)
    @ccall libcurl.curl_strequal(s1::Ptr{Cchar}, s2::Ptr{Cchar})::Cint
end

function curl_strnequal(s1, s2, n)
    @ccall libcurl.curl_strnequal(s1::Ptr{Cchar}, s2::Ptr{Cchar}, n::Csize_t)::Cint
end

mutable struct curl_mime end

mutable struct curl_mimepart end

function curl_mime_init(easy)
    @ccall libcurl.curl_mime_init(easy::Ptr{CURL})::Ptr{curl_mime}
end

function curl_mime_free(mime)
    @ccall libcurl.curl_mime_free(mime::Ptr{curl_mime})::Cvoid
end

function curl_mime_addpart(mime)
    @ccall libcurl.curl_mime_addpart(mime::Ptr{curl_mime})::Ptr{curl_mimepart}
end

function curl_mime_name(part, name)
    @ccall libcurl.curl_mime_name(part::Ptr{curl_mimepart}, name::Ptr{Cchar})::CURLcode
end

function curl_mime_filename(part, filename)
    @ccall libcurl.curl_mime_filename(part::Ptr{curl_mimepart}, filename::Ptr{Cchar})::CURLcode
end

function curl_mime_type(part, mimetype)
    @ccall libcurl.curl_mime_type(part::Ptr{curl_mimepart}, mimetype::Ptr{Cchar})::CURLcode
end

function curl_mime_encoder(part, encoding)
    @ccall libcurl.curl_mime_encoder(part::Ptr{curl_mimepart}, encoding::Ptr{Cchar})::CURLcode
end

function curl_mime_data(part, data, datasize)
    @ccall libcurl.curl_mime_data(part::Ptr{curl_mimepart}, data::Ptr{Cchar}, datasize::Csize_t)::CURLcode
end

function curl_mime_filedata(part, filename)
    @ccall libcurl.curl_mime_filedata(part::Ptr{curl_mimepart}, filename::Ptr{Cchar})::CURLcode
end

function curl_mime_data_cb(part, datasize, readfunc, seekfunc, freefunc, arg)
    @ccall libcurl.curl_mime_data_cb(part::Ptr{curl_mimepart}, datasize::curl_off_t, readfunc::curl_read_callback, seekfunc::curl_seek_callback, freefunc::curl_free_callback, arg::Ptr{Cvoid})::CURLcode
end

function curl_mime_subparts(part, subparts)
    @ccall libcurl.curl_mime_subparts(part::Ptr{curl_mimepart}, subparts::Ptr{curl_mime})::CURLcode
end

struct curl_slist
    data::Ptr{Cchar}
    next::Ptr{curl_slist}
end

function curl_mime_headers(part, headers, take_ownership)
    @ccall libcurl.curl_mime_headers(part::Ptr{curl_mimepart}, headers::Ptr{curl_slist}, take_ownership::Cint)::CURLcode
end

const CURLformoption = UInt32
const CURLFORM_NOTHING = 0 % UInt32
const CURLFORM_COPYNAME = 1 % UInt32
const CURLFORM_PTRNAME = 2 % UInt32
const CURLFORM_NAMELENGTH = 3 % UInt32
const CURLFORM_COPYCONTENTS = 4 % UInt32
const CURLFORM_PTRCONTENTS = 5 % UInt32
const CURLFORM_CONTENTSLENGTH = 6 % UInt32
const CURLFORM_FILECONTENT = 7 % UInt32
const CURLFORM_ARRAY = 8 % UInt32
const CURLFORM_OBSOLETE = 9 % UInt32
const CURLFORM_FILE = 10 % UInt32
const CURLFORM_BUFFER = 11 % UInt32
const CURLFORM_BUFFERPTR = 12 % UInt32
const CURLFORM_BUFFERLENGTH = 13 % UInt32
const CURLFORM_CONTENTTYPE = 14 % UInt32
const CURLFORM_CONTENTHEADER = 15 % UInt32
const CURLFORM_FILENAME = 16 % UInt32
const CURLFORM_END = 17 % UInt32
const CURLFORM_OBSOLETE2 = 18 % UInt32
const CURLFORM_STREAM = 19 % UInt32
const CURLFORM_CONTENTLEN = 20 % UInt32
const CURLFORM_LASTENTRY = 21 % UInt32

mutable struct curl_forms
    option::CURLformoption
    value::Ptr{Cchar}
    curl_forms() = new()
end

const CURLFORMcode = UInt32
const CURL_FORMADD_OK = 0 % UInt32
const CURL_FORMADD_MEMORY = 1 % UInt32
const CURL_FORMADD_OPTION_TWICE = 2 % UInt32
const CURL_FORMADD_NULL = 3 % UInt32
const CURL_FORMADD_UNKNOWN_OPTION = 4 % UInt32
const CURL_FORMADD_INCOMPLETE = 5 % UInt32
const CURL_FORMADD_ILLEGAL_ARRAY = 6 % UInt32
const CURL_FORMADD_DISABLED = 7 % UInt32
const CURL_FORMADD_LAST = 8 % UInt32

# automatic type deduction for variadic arguments may not be what you want, please use with caution
@generated function curl_formadd(httppost, last_post, va_list...)
        :(@ccall(libcurl.curl_formadd(httppost::Ptr{Ptr{curl_httppost}}, last_post::Ptr{Ptr{curl_httppost}}; $(to_c_type_pairs(va_list)...))::CURLFORMcode))
    end

# typedef size_t ( * curl_formget_callback ) ( void * arg , const char * buf , size_t len )
const curl_formget_callback = Ptr{Cvoid}

function curl_formget(form, arg, append)
    @ccall libcurl.curl_formget(form::Ptr{curl_httppost}, arg::Ptr{Cvoid}, append::curl_formget_callback)::Cint
end

function curl_formfree(form)
    @ccall libcurl.curl_formfree(form::Ptr{curl_httppost})::Cvoid
end

function curl_getenv(variable)
    @ccall libcurl.curl_getenv(variable::Ptr{Cchar})::Ptr{Cchar}
end

function curl_version()
    @ccall libcurl.curl_version()::Ptr{Cchar}
end

function curl_easy_escape(handle, string, length)
    @ccall libcurl.curl_easy_escape(handle::Ptr{CURL}, string::Ptr{Cchar}, length::Cint)::Ptr{Cchar}
end

function curl_escape(string, length)
    @ccall libcurl.curl_escape(string::Ptr{Cchar}, length::Cint)::Ptr{Cchar}
end

function curl_easy_unescape(handle, string, length, outlength)
    @ccall libcurl.curl_easy_unescape(handle::Ptr{CURL}, string::Ptr{Cchar}, length::Cint, outlength::Ptr{Cint})::Ptr{Cchar}
end

function curl_unescape(string, length)
    @ccall libcurl.curl_unescape(string::Ptr{Cchar}, length::Cint)::Ptr{Cchar}
end

function curl_free(p)
    @ccall libcurl.curl_free(p::Ptr{Cvoid})::Cvoid
end

function curl_global_init(flags)
    @ccall libcurl.curl_global_init(flags::Clong)::CURLcode
end

function curl_global_init_mem(flags, m, f, r, s, c)
    @ccall libcurl.curl_global_init_mem(flags::Clong, m::curl_malloc_callback, f::curl_free_callback, r::curl_realloc_callback, s::curl_strdup_callback, c::curl_calloc_callback)::CURLcode
end

function curl_global_cleanup()
    @ccall libcurl.curl_global_cleanup()::Cvoid
end

mutable struct curl_ssl_backend
    id::curl_sslbackend
    name::Ptr{Cchar}
    curl_ssl_backend() = new()
end

const CURLsslset = UInt32
const CURLSSLSET_OK = 0 % UInt32
const CURLSSLSET_UNKNOWN_BACKEND = 1 % UInt32
const CURLSSLSET_TOO_LATE = 2 % UInt32
const CURLSSLSET_NO_BACKENDS = 3 % UInt32

function curl_global_sslset(id, name, avail)
    @ccall libcurl.curl_global_sslset(id::curl_sslbackend, name::Ptr{Cchar}, avail::Ptr{Ptr{Ptr{curl_ssl_backend}}})::CURLsslset
end

function curl_slist_append(arg1, arg2)
    @ccall libcurl.curl_slist_append(arg1::Ptr{curl_slist}, arg2::Ptr{Cchar})::Ptr{curl_slist}
end

function curl_slist_free_all(arg1)
    @ccall libcurl.curl_slist_free_all(arg1::Ptr{curl_slist})::Cvoid
end

function curl_getdate(p, unused)
    @ccall libcurl.curl_getdate(p::Ptr{Cchar}, unused::Ptr{time_t})::time_t
end

mutable struct curl_certinfo
    num_of_certs::Cint
    certinfo::Ptr{Ptr{curl_slist}}
    curl_certinfo() = new()
end

mutable struct curl_tlssessioninfo
    backend::curl_sslbackend
    internals::Ptr{Cvoid}
    curl_tlssessioninfo() = new()
end

const CURLINFO = UInt32
const CURLINFO_NONE = 0 % UInt32
const CURLINFO_EFFECTIVE_URL = 1048577 % UInt32
const CURLINFO_RESPONSE_CODE = 2097154 % UInt32
const CURLINFO_TOTAL_TIME = 3145731 % UInt32
const CURLINFO_NAMELOOKUP_TIME = 3145732 % UInt32
const CURLINFO_CONNECT_TIME = 3145733 % UInt32
const CURLINFO_PRETRANSFER_TIME = 3145734 % UInt32
const CURLINFO_SIZE_UPLOAD = 3145735 % UInt32
const CURLINFO_SIZE_UPLOAD_T = 6291463 % UInt32
const CURLINFO_SIZE_DOWNLOAD = 3145736 % UInt32
const CURLINFO_SIZE_DOWNLOAD_T = 6291464 % UInt32
const CURLINFO_SPEED_DOWNLOAD = 3145737 % UInt32
const CURLINFO_SPEED_DOWNLOAD_T = 6291465 % UInt32
const CURLINFO_SPEED_UPLOAD = 3145738 % UInt32
const CURLINFO_SPEED_UPLOAD_T = 6291466 % UInt32
const CURLINFO_HEADER_SIZE = 2097163 % UInt32
const CURLINFO_REQUEST_SIZE = 2097164 % UInt32
const CURLINFO_SSL_VERIFYRESULT = 2097165 % UInt32
const CURLINFO_FILETIME = 2097166 % UInt32
const CURLINFO_FILETIME_T = 6291470 % UInt32
const CURLINFO_CONTENT_LENGTH_DOWNLOAD = 3145743 % UInt32
const CURLINFO_CONTENT_LENGTH_DOWNLOAD_T = 6291471 % UInt32
const CURLINFO_CONTENT_LENGTH_UPLOAD = 3145744 % UInt32
const CURLINFO_CONTENT_LENGTH_UPLOAD_T = 6291472 % UInt32
const CURLINFO_STARTTRANSFER_TIME = 3145745 % UInt32
const CURLINFO_CONTENT_TYPE = 1048594 % UInt32
const CURLINFO_REDIRECT_TIME = 3145747 % UInt32
const CURLINFO_REDIRECT_COUNT = 2097172 % UInt32
const CURLINFO_PRIVATE = 1048597 % UInt32
const CURLINFO_HTTP_CONNECTCODE = 2097174 % UInt32
const CURLINFO_HTTPAUTH_AVAIL = 2097175 % UInt32
const CURLINFO_PROXYAUTH_AVAIL = 2097176 % UInt32
const CURLINFO_OS_ERRNO = 2097177 % UInt32
const CURLINFO_NUM_CONNECTS = 2097178 % UInt32
const CURLINFO_SSL_ENGINES = 4194331 % UInt32
const CURLINFO_COOKIELIST = 4194332 % UInt32
const CURLINFO_LASTSOCKET = 2097181 % UInt32
const CURLINFO_FTP_ENTRY_PATH = 1048606 % UInt32
const CURLINFO_REDIRECT_URL = 1048607 % UInt32
const CURLINFO_PRIMARY_IP = 1048608 % UInt32
const CURLINFO_APPCONNECT_TIME = 3145761 % UInt32
const CURLINFO_CERTINFO = 4194338 % UInt32
const CURLINFO_CONDITION_UNMET = 2097187 % UInt32
const CURLINFO_RTSP_SESSION_ID = 1048612 % UInt32
const CURLINFO_RTSP_CLIENT_CSEQ = 2097189 % UInt32
const CURLINFO_RTSP_SERVER_CSEQ = 2097190 % UInt32
const CURLINFO_RTSP_CSEQ_RECV = 2097191 % UInt32
const CURLINFO_PRIMARY_PORT = 2097192 % UInt32
const CURLINFO_LOCAL_IP = 1048617 % UInt32
const CURLINFO_LOCAL_PORT = 2097194 % UInt32
const CURLINFO_TLS_SESSION = 4194347 % UInt32
const CURLINFO_ACTIVESOCKET = 5242924 % UInt32
const CURLINFO_TLS_SSL_PTR = 4194349 % UInt32
const CURLINFO_HTTP_VERSION = 2097198 % UInt32
const CURLINFO_PROXY_SSL_VERIFYRESULT = 2097199 % UInt32
const CURLINFO_PROTOCOL = 2097200 % UInt32
const CURLINFO_SCHEME = 1048625 % UInt32
const CURLINFO_TOTAL_TIME_T = 6291506 % UInt32
const CURLINFO_NAMELOOKUP_TIME_T = 6291507 % UInt32
const CURLINFO_CONNECT_TIME_T = 6291508 % UInt32
const CURLINFO_PRETRANSFER_TIME_T = 6291509 % UInt32
const CURLINFO_STARTTRANSFER_TIME_T = 6291510 % UInt32
const CURLINFO_REDIRECT_TIME_T = 6291511 % UInt32
const CURLINFO_APPCONNECT_TIME_T = 6291512 % UInt32
const CURLINFO_RETRY_AFTER = 6291513 % UInt32
const CURLINFO_EFFECTIVE_METHOD = 1048634 % UInt32
const CURLINFO_PROXY_ERROR = 2097211 % UInt32
const CURLINFO_LASTONE = 59 % UInt32

const curl_closepolicy = UInt32
const CURLCLOSEPOLICY_NONE = 0 % UInt32
const CURLCLOSEPOLICY_OLDEST = 1 % UInt32
const CURLCLOSEPOLICY_LEAST_RECENTLY_USED = 2 % UInt32
const CURLCLOSEPOLICY_LEAST_TRAFFIC = 3 % UInt32
const CURLCLOSEPOLICY_SLOWEST = 4 % UInt32
const CURLCLOSEPOLICY_CALLBACK = 5 % UInt32
const CURLCLOSEPOLICY_LAST = 6 % UInt32

const curl_lock_data = UInt32
const CURL_LOCK_DATA_NONE = 0 % UInt32
const CURL_LOCK_DATA_SHARE = 1 % UInt32
const CURL_LOCK_DATA_COOKIE = 2 % UInt32
const CURL_LOCK_DATA_DNS = 3 % UInt32
const CURL_LOCK_DATA_SSL_SESSION = 4 % UInt32
const CURL_LOCK_DATA_CONNECT = 5 % UInt32
const CURL_LOCK_DATA_PSL = 6 % UInt32
const CURL_LOCK_DATA_LAST = 7 % UInt32

const curl_lock_access = UInt32
const CURL_LOCK_ACCESS_NONE = 0 % UInt32
const CURL_LOCK_ACCESS_SHARED = 1 % UInt32
const CURL_LOCK_ACCESS_SINGLE = 2 % UInt32
const CURL_LOCK_ACCESS_LAST = 3 % UInt32

# typedef void ( * curl_lock_function ) ( CURL * handle , curl_lock_data data , curl_lock_access locktype , void * userptr )
const curl_lock_function = Ptr{Cvoid}

# typedef void ( * curl_unlock_function ) ( CURL * handle , curl_lock_data data , void * userptr )
const curl_unlock_function = Ptr{Cvoid}

const CURLSHcode = UInt32
const CURLSHE_OK = 0 % UInt32
const CURLSHE_BAD_OPTION = 1 % UInt32
const CURLSHE_IN_USE = 2 % UInt32
const CURLSHE_INVALID = 3 % UInt32
const CURLSHE_NOMEM = 4 % UInt32
const CURLSHE_NOT_BUILT_IN = 5 % UInt32
const CURLSHE_LAST = 6 % UInt32

const CURLSHoption = UInt32
const CURLSHOPT_NONE = 0 % UInt32
const CURLSHOPT_SHARE = 1 % UInt32
const CURLSHOPT_UNSHARE = 2 % UInt32
const CURLSHOPT_LOCKFUNC = 3 % UInt32
const CURLSHOPT_UNLOCKFUNC = 4 % UInt32
const CURLSHOPT_USERDATA = 5 % UInt32
const CURLSHOPT_LAST = 6 % UInt32

function curl_share_init()
    @ccall libcurl.curl_share_init()::Ptr{CURLSH}
end

# automatic type deduction for variadic arguments may not be what you want, please use with caution
@generated function curl_share_setopt(arg1, option, va_list...)
        :(@ccall(libcurl.curl_share_setopt(arg1::Ptr{CURLSH}, option::CURLSHoption; $(to_c_type_pairs(va_list)...))::CURLSHcode))
    end

function curl_share_cleanup(arg1)
    @ccall libcurl.curl_share_cleanup(arg1::Ptr{CURLSH})::CURLSHcode
end

const CURLversion = UInt32
const CURLVERSION_FIRST = 0 % UInt32
const CURLVERSION_SECOND = 1 % UInt32
const CURLVERSION_THIRD = 2 % UInt32
const CURLVERSION_FOURTH = 3 % UInt32
const CURLVERSION_FIFTH = 4 % UInt32
const CURLVERSION_SIXTH = 5 % UInt32
const CURLVERSION_SEVENTH = 6 % UInt32
const CURLVERSION_EIGHTH = 7 % UInt32
const CURLVERSION_LAST = 8 % UInt32

mutable struct curl_version_info_data
    age::CURLversion
    version::Ptr{Cchar}
    version_num::Cuint
    host::Ptr{Cchar}
    features::Cint
    ssl_version::Ptr{Cchar}
    ssl_version_num::Clong
    libz_version::Ptr{Cchar}
    protocols::Ptr{Ptr{Cchar}}
    ares::Ptr{Cchar}
    ares_num::Cint
    libidn::Ptr{Cchar}
    iconv_ver_num::Cint
    libssh_version::Ptr{Cchar}
    brotli_ver_num::Cuint
    brotli_version::Ptr{Cchar}
    nghttp2_ver_num::Cuint
    nghttp2_version::Ptr{Cchar}
    quic_version::Ptr{Cchar}
    cainfo::Ptr{Cchar}
    capath::Ptr{Cchar}
    zstd_ver_num::Cuint
    zstd_version::Ptr{Cchar}
    curl_version_info_data() = new()
end

function curl_version_info(arg1)
    @ccall libcurl.curl_version_info(arg1::CURLversion)::Ptr{curl_version_info_data}
end

function curl_easy_strerror(arg1)
    @ccall libcurl.curl_easy_strerror(arg1::CURLcode)::Ptr{Cchar}
end

function curl_share_strerror(arg1)
    @ccall libcurl.curl_share_strerror(arg1::CURLSHcode)::Ptr{Cchar}
end

function curl_easy_pause(handle, bitmask)
    @ccall libcurl.curl_easy_pause(handle::Ptr{CURL}, bitmask::Cint)::CURLcode
end

mutable struct curl_blob
    data::Ptr{Cvoid}
    len::Csize_t
    flags::Cuint
    curl_blob() = new()
end

function curl_easy_init()
    @ccall libcurl.curl_easy_init()::Ptr{CURL}
end

# automatic type deduction for variadic arguments may not be what you want, please use with caution
@generated function curl_easy_setopt(curl, option, va_list...)
        :(@ccall(libcurl.curl_easy_setopt(curl::Ptr{CURL}, option::CURLoption; $(to_c_type_pairs(va_list)...))::CURLcode))
    end

function curl_easy_perform(curl)
    @ccall libcurl.curl_easy_perform(curl::Ptr{CURL})::CURLcode
end

function curl_easy_cleanup(curl)
    @ccall libcurl.curl_easy_cleanup(curl::Ptr{CURL})::Cvoid
end

# automatic type deduction for variadic arguments may not be what you want, please use with caution
@generated function curl_easy_getinfo(curl, info, va_list...)
        :(@ccall(libcurl.curl_easy_getinfo(curl::Ptr{CURL}, info::CURLINFO; $(to_c_type_pairs(va_list)...))::CURLcode))
    end

function curl_easy_duphandle(curl)
    @ccall libcurl.curl_easy_duphandle(curl::Ptr{CURL})::Ptr{CURL}
end

function curl_easy_reset(curl)
    @ccall libcurl.curl_easy_reset(curl::Ptr{CURL})::Cvoid
end

function curl_easy_recv(curl, buffer, buflen, n)
    @ccall libcurl.curl_easy_recv(curl::Ptr{CURL}, buffer::Ptr{Cvoid}, buflen::Csize_t, n::Ptr{Csize_t})::CURLcode
end

function curl_easy_send(curl, buffer, buflen, n)
    @ccall libcurl.curl_easy_send(curl::Ptr{CURL}, buffer::Ptr{Cvoid}, buflen::Csize_t, n::Ptr{Csize_t})::CURLcode
end

function curl_easy_upkeep(curl)
    @ccall libcurl.curl_easy_upkeep(curl::Ptr{CURL})::CURLcode
end

const CURLMSG = UInt32
const CURLMSG_NONE = 0 % UInt32
const CURLMSG_DONE = 1 % UInt32
const CURLMSG_LAST = 2 % UInt32

struct __JL_Ctag_54
    data::NTuple{8, UInt8}
end

function Base.getproperty(x::Ptr{__JL_Ctag_54}, f::Symbol)
    f === :whatever && return Ptr{Ptr{Cvoid}}(x + 0)
    f === :result && return Ptr{CURLcode}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::__JL_Ctag_54, f::Symbol)
    r = Ref{__JL_Ctag_54}(x)
    ptr = Base.unsafe_convert(Ptr{__JL_Ctag_54}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{__JL_Ctag_54}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct CURLMsg
    data::NTuple{24, UInt8}
end

function Base.getproperty(x::Ptr{CURLMsg}, f::Symbol)
    f === :msg && return Ptr{CURLMSG}(x + 0)
    f === :easy_handle && return Ptr{Ptr{CURL}}(x + 8)
    f === :data && return Ptr{__JL_Ctag_54}(x + 16)
    return getfield(x, f)
end

function Base.getproperty(x::CURLMsg, f::Symbol)
    r = Ref{CURLMsg}(x)
    ptr = Base.unsafe_convert(Ptr{CURLMsg}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{CURLMsg}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

mutable struct curl_waitfd
    fd::curl_socket_t
    events::Cshort
    revents::Cshort
    curl_waitfd() = new()
end

function curl_multi_init()
    @ccall libcurl.curl_multi_init()::Ptr{CURLM}
end

function curl_multi_add_handle(multi_handle, curl_handle)
    @ccall libcurl.curl_multi_add_handle(multi_handle::Ptr{CURLM}, curl_handle::Ptr{CURL})::CURLMcode
end

function curl_multi_remove_handle(multi_handle, curl_handle)
    @ccall libcurl.curl_multi_remove_handle(multi_handle::Ptr{CURLM}, curl_handle::Ptr{CURL})::CURLMcode
end

function curl_multi_fdset(multi_handle, read_fd_set, write_fd_set, exc_fd_set, max_fd)
    @ccall libcurl.curl_multi_fdset(multi_handle::Ptr{CURLM}, read_fd_set::Ptr{fd_set}, write_fd_set::Ptr{fd_set}, exc_fd_set::Ptr{fd_set}, max_fd::Ptr{Cint})::CURLMcode
end

function curl_multi_wait(multi_handle, extra_fds, extra_nfds, timeout_ms, ret)
    @ccall libcurl.curl_multi_wait(multi_handle::Ptr{CURLM}, extra_fds::Ptr{curl_waitfd}, extra_nfds::Cuint, timeout_ms::Cint, ret::Ptr{Cint})::CURLMcode
end

function curl_multi_poll(multi_handle, extra_fds, extra_nfds, timeout_ms, ret)
    @ccall libcurl.curl_multi_poll(multi_handle::Ptr{CURLM}, extra_fds::Ptr{curl_waitfd}, extra_nfds::Cuint, timeout_ms::Cint, ret::Ptr{Cint})::CURLMcode
end

function curl_multi_wakeup(multi_handle)
    @ccall libcurl.curl_multi_wakeup(multi_handle::Ptr{CURLM})::CURLMcode
end

function curl_multi_perform(multi_handle, running_handles)
    @ccall libcurl.curl_multi_perform(multi_handle::Ptr{CURLM}, running_handles::Ptr{Cint})::CURLMcode
end

function curl_multi_cleanup(multi_handle)
    @ccall libcurl.curl_multi_cleanup(multi_handle::Ptr{CURLM})::CURLMcode
end

function curl_multi_info_read(multi_handle, msgs_in_queue)
    @ccall libcurl.curl_multi_info_read(multi_handle::Ptr{CURLM}, msgs_in_queue::Ptr{Cint})::Ptr{CURLMsg}
end

function curl_multi_strerror(arg1)
    @ccall libcurl.curl_multi_strerror(arg1::CURLMcode)::Ptr{Cchar}
end

# typedef int ( * curl_socket_callback ) ( CURL * easy , /* easy handle */ curl_socket_t s , /* socket */ int what , /* see above */ void * userp , /* private callback
#                                                        pointer */ void * socketp )
const curl_socket_callback = Ptr{Cvoid}

# typedef int ( * curl_multi_timer_callback ) ( CURLM * multi , /* multi handle */ long timeout_ms , /* see above */ void * userp )
const curl_multi_timer_callback = Ptr{Cvoid}

function curl_multi_socket_all(multi_handle, running_handles)
    @ccall libcurl.curl_multi_socket_all(multi_handle::Ptr{CURLM}, running_handles::Ptr{Cint})::CURLMcode
end

function curl_multi_timeout(multi_handle, milliseconds)
    @ccall libcurl.curl_multi_timeout(multi_handle::Ptr{CURLM}, milliseconds::Ptr{Clong})::CURLMcode
end

const CURLMoption = UInt32
const CURLMOPT_SOCKETFUNCTION = 20001 % UInt32
const CURLMOPT_SOCKETDATA = 10002 % UInt32
const CURLMOPT_PIPELINING = 3 % UInt32
const CURLMOPT_TIMERFUNCTION = 20004 % UInt32
const CURLMOPT_TIMERDATA = 10005 % UInt32
const CURLMOPT_MAXCONNECTS = 6 % UInt32
const CURLMOPT_MAX_HOST_CONNECTIONS = 7 % UInt32
const CURLMOPT_MAX_PIPELINE_LENGTH = 8 % UInt32
const CURLMOPT_CONTENT_LENGTH_PENALTY_SIZE = 30009 % UInt32
const CURLMOPT_CHUNK_LENGTH_PENALTY_SIZE = 30010 % UInt32
const CURLMOPT_PIPELINING_SITE_BL = 10011 % UInt32
const CURLMOPT_PIPELINING_SERVER_BL = 10012 % UInt32
const CURLMOPT_MAX_TOTAL_CONNECTIONS = 13 % UInt32
const CURLMOPT_PUSHFUNCTION = 20014 % UInt32
const CURLMOPT_PUSHDATA = 10015 % UInt32
const CURLMOPT_MAX_CONCURRENT_STREAMS = 16 % UInt32
const CURLMOPT_LASTENTRY = 17 % UInt32

# automatic type deduction for variadic arguments may not be what you want, please use with caution
@generated function curl_multi_setopt(multi_handle, option, va_list...)
        :(@ccall(libcurl.curl_multi_setopt(multi_handle::Ptr{CURLM}, option::CURLMoption; $(to_c_type_pairs(va_list)...))::CURLMcode))
    end

function curl_multi_assign(multi_handle, sockfd, sockp)
    @ccall libcurl.curl_multi_assign(multi_handle::Ptr{CURLM}, sockfd::curl_socket_t, sockp::Ptr{Cvoid})::CURLMcode
end

mutable struct curl_pushheaders end

function curl_pushheader_bynum(h, num)
    @ccall libcurl.curl_pushheader_bynum(h::Ptr{curl_pushheaders}, num::Csize_t)::Ptr{Cchar}
end

function curl_pushheader_byname(h, name)
    @ccall libcurl.curl_pushheader_byname(h::Ptr{curl_pushheaders}, name::Ptr{Cchar})::Ptr{Cchar}
end

# typedef int ( * curl_push_callback ) ( CURL * parent , CURL * easy , size_t num_headers , struct curl_pushheaders * headers , void * userp )
const curl_push_callback = Ptr{Cvoid}

const CURLUcode = UInt32
const CURLUE_OK = 0 % UInt32
const CURLUE_BAD_HANDLE = 1 % UInt32
const CURLUE_BAD_PARTPOINTER = 2 % UInt32
const CURLUE_MALFORMED_INPUT = 3 % UInt32
const CURLUE_BAD_PORT_NUMBER = 4 % UInt32
const CURLUE_UNSUPPORTED_SCHEME = 5 % UInt32
const CURLUE_URLDECODE = 6 % UInt32
const CURLUE_OUT_OF_MEMORY = 7 % UInt32
const CURLUE_USER_NOT_ALLOWED = 8 % UInt32
const CURLUE_UNKNOWN_PART = 9 % UInt32
const CURLUE_NO_SCHEME = 10 % UInt32
const CURLUE_NO_USER = 11 % UInt32
const CURLUE_NO_PASSWORD = 12 % UInt32
const CURLUE_NO_OPTIONS = 13 % UInt32
const CURLUE_NO_HOST = 14 % UInt32
const CURLUE_NO_PORT = 15 % UInt32
const CURLUE_NO_QUERY = 16 % UInt32
const CURLUE_NO_FRAGMENT = 17 % UInt32

const CURLUPart = UInt32
const CURLUPART_URL = 0 % UInt32
const CURLUPART_SCHEME = 1 % UInt32
const CURLUPART_USER = 2 % UInt32
const CURLUPART_PASSWORD = 3 % UInt32
const CURLUPART_OPTIONS = 4 % UInt32
const CURLUPART_HOST = 5 % UInt32
const CURLUPART_PORT = 6 % UInt32
const CURLUPART_PATH = 7 % UInt32
const CURLUPART_QUERY = 8 % UInt32
const CURLUPART_FRAGMENT = 9 % UInt32
const CURLUPART_ZONEID = 10 % UInt32

mutable struct Curl_URL end

const CURLU = Curl_URL

function curl_url()
    @ccall libcurl.curl_url()::Ptr{CURLU}
end

function curl_url_cleanup(handle)
    @ccall libcurl.curl_url_cleanup(handle::Ptr{CURLU})::Cvoid
end

function curl_url_dup(in)
    @ccall libcurl.curl_url_dup(in::Ptr{CURLU})::Ptr{CURLU}
end

function curl_url_get(handle, what, part, flags)
    @ccall libcurl.curl_url_get(handle::Ptr{CURLU}, what::CURLUPart, part::Ptr{Ptr{Cchar}}, flags::Cuint)::CURLUcode
end

function curl_url_set(handle, what, part, flags)
    @ccall libcurl.curl_url_set(handle::Ptr{CURLU}, what::CURLUPart, part::Ptr{Cchar}, flags::Cuint)::CURLUcode
end

const curl_easytype = UInt32
const CURLOT_LONG = 0 % UInt32
const CURLOT_VALUES = 1 % UInt32
const CURLOT_OFF_T = 2 % UInt32
const CURLOT_OBJECT = 3 % UInt32
const CURLOT_STRING = 4 % UInt32
const CURLOT_SLIST = 5 % UInt32
const CURLOT_CBPTR = 6 % UInt32
const CURLOT_BLOB = 7 % UInt32
const CURLOT_FUNCTION = 8 % UInt32

mutable struct curl_easyoption
    name::Ptr{Cchar}
    id::CURLoption
    type::curl_easytype
    flags::Cuint
    curl_easyoption() = new()
end

function curl_easy_option_by_name(name)
    @ccall libcurl.curl_easy_option_by_name(name::Ptr{Cchar})::Ptr{curl_easyoption}
end

function curl_easy_option_by_id(id)
    @ccall libcurl.curl_easy_option_by_id(id::CURLoption)::Ptr{curl_easyoption}
end

function curl_easy_option_next(prev)
    @ccall libcurl.curl_easy_option_next(prev::Ptr{curl_easyoption})::Ptr{curl_easyoption}
end

const LIBCURL_COPYRIGHT = "1996 - 2020 Daniel Stenberg, <daniel@haxx.se>."

const LIBCURL_VERSION = "7.73.0"

const LIBCURL_VERSION_MAJOR = 7

const LIBCURL_VERSION_MINOR = 73

const LIBCURL_VERSION_PATCH = 0

const LIBCURL_VERSION_NUM = 0x00074900

const LIBCURL_TIMESTAMP = "2020-10-14"

const CURL_TYPEOF_CURL_OFF_T = Clong

const CURL_FORMAT_CURL_OFF_T = "ld"

const CURL_FORMAT_CURL_OFF_TU = "lu"

const CURL_TYPEOF_CURL_SOCKLEN_T = socklen_t

const CURL_SOCKET_BAD = -1

const CURLSSLBACKEND_LIBRESSL = CURLSSLBACKEND_OPENSSL

const CURLSSLBACKEND_BORINGSSL = CURLSSLBACKEND_OPENSSL

const CURLSSLBACKEND_CYASSL = CURLSSLBACKEND_WOLFSSL

const CURLSSLBACKEND_DARWINSSL = CURLSSLBACKEND_SECURETRANSPORT

const CURL_HTTPPOST_FILENAME = 1 << 0

const CURL_HTTPPOST_READFILE = 1 << 1

const CURL_HTTPPOST_PTRNAME = 1 << 2

const CURL_HTTPPOST_PTRCONTENTS = 1 << 3

const CURL_HTTPPOST_BUFFER = 1 << 4

const CURL_HTTPPOST_PTRBUFFER = 1 << 5

const CURL_HTTPPOST_CALLBACK = 1 << 6

const CURL_HTTPPOST_LARGE = 1 << 7

const CURL_PROGRESSFUNC_CONTINUE = 0x10000001

const CURL_MAX_READ_SIZE = 524288

const CURL_MAX_WRITE_SIZE = 16384

const CURL_MAX_HTTP_HEADER = 100 * 1024

const CURL_WRITEFUNC_PAUSE = 0x10000001

const CURLFINFOFLAG_KNOWN_FILENAME = 1 << 0

const CURLFINFOFLAG_KNOWN_FILETYPE = 1 << 1

const CURLFINFOFLAG_KNOWN_TIME = 1 << 2

const CURLFINFOFLAG_KNOWN_PERM = 1 << 3

const CURLFINFOFLAG_KNOWN_UID = 1 << 4

const CURLFINFOFLAG_KNOWN_GID = 1 << 5

const CURLFINFOFLAG_KNOWN_SIZE = 1 << 6

const CURLFINFOFLAG_KNOWN_HLINKCOUNT = 1 << 7

const CURL_CHUNK_BGN_FUNC_OK = 0

const CURL_CHUNK_BGN_FUNC_FAIL = 1

const CURL_CHUNK_BGN_FUNC_SKIP = 2

const CURL_CHUNK_END_FUNC_OK = 0

const CURL_CHUNK_END_FUNC_FAIL = 1

const CURL_FNMATCHFUNC_MATCH = 0

const CURL_FNMATCHFUNC_NOMATCH = 1

const CURL_FNMATCHFUNC_FAIL = 2

const CURL_SEEKFUNC_OK = 0

const CURL_SEEKFUNC_FAIL = 1

const CURL_SEEKFUNC_CANTSEEK = 2

const CURL_READFUNC_ABORT = 0x10000000

const CURL_READFUNC_PAUSE = 0x10000001

const CURL_TRAILERFUNC_OK = 0

const CURL_TRAILERFUNC_ABORT = 1

const CURL_SOCKOPT_OK = 0

const CURL_SOCKOPT_ERROR = 1

const CURL_SOCKOPT_ALREADY_CONNECTED = 2

const CURLE_OBSOLETE16 = CURLE_HTTP2

const CURLE_OBSOLETE10 = CURLE_FTP_ACCEPT_FAILED

const CURLE_OBSOLETE12 = CURLE_FTP_ACCEPT_TIMEOUT

const CURLOPT_ENCODING = CURLOPT_ACCEPT_ENCODING

const CURLE_FTP_WEIRD_SERVER_REPLY = CURLE_WEIRD_SERVER_REPLY

const CURLE_SSL_CACERT = CURLE_PEER_FAILED_VERIFICATION

const CURLE_UNKNOWN_TELNET_OPTION = CURLE_UNKNOWN_OPTION

const CURLE_SSL_PEER_CERTIFICATE = CURLE_PEER_FAILED_VERIFICATION

const CURLE_OBSOLETE = CURLE_OBSOLETE50

const CURLE_BAD_PASSWORD_ENTERED = CURLE_OBSOLETE46

const CURLE_BAD_CALLING_ORDER = CURLE_OBSOLETE44

const CURLE_FTP_USER_PASSWORD_INCORRECT = CURLE_OBSOLETE10

const CURLE_FTP_CANT_RECONNECT = CURLE_OBSOLETE16

const CURLE_FTP_COULDNT_GET_SIZE = CURLE_OBSOLETE32

const CURLE_FTP_COULDNT_SET_ASCII = CURLE_OBSOLETE29

const CURLE_FTP_WEIRD_USER_REPLY = CURLE_OBSOLETE12

const CURLE_FTP_WRITE_ERROR = CURLE_OBSOLETE20

const CURLE_LIBRARY_NOT_FOUND = CURLE_OBSOLETE40

const CURLE_MALFORMAT_USER = CURLE_OBSOLETE24

const CURLE_SHARE_IN_USE = CURLE_OBSOLETE57

const CURLE_URL_MALFORMAT_USER = CURLE_NOT_BUILT_IN

const CURLE_FTP_ACCESS_DENIED = CURLE_REMOTE_ACCESS_DENIED

const CURLE_FTP_COULDNT_SET_BINARY = CURLE_FTP_COULDNT_SET_TYPE

const CURLE_FTP_QUOTE_ERROR = CURLE_QUOTE_ERROR

const CURLE_TFTP_DISKFULL = CURLE_REMOTE_DISK_FULL

const CURLE_TFTP_EXISTS = CURLE_REMOTE_FILE_EXISTS

const CURLE_HTTP_RANGE_ERROR = CURLE_RANGE_ERROR

const CURLE_FTP_SSL_FAILED = CURLE_USE_SSL_FAILED

const CURLE_OPERATION_TIMEOUTED = CURLE_OPERATION_TIMEDOUT

const CURLE_HTTP_NOT_FOUND = CURLE_HTTP_RETURNED_ERROR

const CURLE_HTTP_PORT_FAILED = CURLE_INTERFACE_FAILED

const CURLE_FTP_COULDNT_STOR_FILE = CURLE_UPLOAD_FAILED

const CURLE_FTP_PARTIAL_FILE = CURLE_PARTIAL_FILE

const CURLE_FTP_BAD_DOWNLOAD_RESUME = CURLE_BAD_DOWNLOAD_RESUME

const CURLE_ALREADY_COMPLETE = 99999

const CURLOPT_FILE = CURLOPT_WRITEDATA

const CURLOPT_INFILE = CURLOPT_READDATA

const CURLOPT_WRITEHEADER = CURLOPT_HEADERDATA

const CURLOPT_WRITEINFO = CURLOPT_OBSOLETE40

const CURLOPT_CLOSEPOLICY = CURLOPT_OBSOLETE72

const CURLAUTH_NONE = Culong(0)

const CURLAUTH_BASIC = Culong(1) << 0

const CURLAUTH_DIGEST = Culong(1) << 1

const CURLAUTH_NEGOTIATE = Culong(1) << 2

const CURLAUTH_GSSNEGOTIATE = CURLAUTH_NEGOTIATE

const CURLAUTH_GSSAPI = CURLAUTH_NEGOTIATE

const CURLAUTH_NTLM = Culong(1) << 3

const CURLAUTH_DIGEST_IE = Culong(1) << 4

const CURLAUTH_NTLM_WB = Culong(1) << 5

const CURLAUTH_BEARER = Culong(1) << 6

const CURLAUTH_ONLY = Culong(1) << 31

const CURLAUTH_ANY = ~CURLAUTH_DIGEST_IE

const CURLAUTH_ANYSAFE = ~(CURLAUTH_BASIC | CURLAUTH_DIGEST_IE)

const CURLSSH_AUTH_ANY = ~0

const CURLSSH_AUTH_NONE = 0

const CURLSSH_AUTH_PUBLICKEY = 1 << 0

const CURLSSH_AUTH_PASSWORD = 1 << 1

const CURLSSH_AUTH_HOST = 1 << 2

const CURLSSH_AUTH_KEYBOARD = 1 << 3

const CURLSSH_AUTH_AGENT = 1 << 4

const CURLSSH_AUTH_GSSAPI = 1 << 5

const CURLSSH_AUTH_DEFAULT = CURLSSH_AUTH_ANY

const CURLGSSAPI_DELEGATION_NONE = 0

const CURLGSSAPI_DELEGATION_POLICY_FLAG = 1 << 0

const CURLGSSAPI_DELEGATION_FLAG = 1 << 1

const CURL_ERROR_SIZE = 256

const CURLSSLOPT_ALLOW_BEAST = 1 << 0

const CURLSSLOPT_NO_REVOKE = 1 << 1

const CURLSSLOPT_NO_PARTIALCHAIN = 1 << 2

const CURLSSLOPT_REVOKE_BEST_EFFORT = 1 << 3

const CURLSSLOPT_NATIVE_CA = 1 << 4

const CURL_HET_DEFAULT = Clong(200)

const CURL_UPKEEP_INTERVAL_DEFAULT = Clong(60000)

const CURLFTPSSL_NONE = CURLUSESSL_NONE

const CURLFTPSSL_TRY = CURLUSESSL_TRY

const CURLFTPSSL_CONTROL = CURLUSESSL_CONTROL

const CURLFTPSSL_ALL = CURLUSESSL_ALL

const CURLFTPSSL_LAST = CURLUSESSL_LAST

const curl_ftpssl = curl_usessl

const CURLHEADER_UNIFIED = 0

const CURLHEADER_SEPARATE = 1 << 0

const CURLALTSVC_IMMEDIATELY = 1 << 0

const CURLALTSVC_READONLYFILE = 1 << 2

const CURLALTSVC_H1 = 1 << 3

const CURLALTSVC_H2 = 1 << 4

const CURLALTSVC_H3 = 1 << 5

const CURLPROTO_HTTP = 1 << 0

const CURLPROTO_HTTPS = 1 << 1

const CURLPROTO_FTP = 1 << 2

const CURLPROTO_FTPS = 1 << 3

const CURLPROTO_SCP = 1 << 4

const CURLPROTO_SFTP = 1 << 5

const CURLPROTO_TELNET = 1 << 6

const CURLPROTO_LDAP = 1 << 7

const CURLPROTO_LDAPS = 1 << 8

const CURLPROTO_DICT = 1 << 9

const CURLPROTO_FILE = 1 << 10

const CURLPROTO_TFTP = 1 << 11

const CURLPROTO_IMAP = 1 << 12

const CURLPROTO_IMAPS = 1 << 13

const CURLPROTO_POP3 = 1 << 14

const CURLPROTO_POP3S = 1 << 15

const CURLPROTO_SMTP = 1 << 16

const CURLPROTO_SMTPS = 1 << 17

const CURLPROTO_RTSP = 1 << 18

const CURLPROTO_RTMP = 1 << 19

const CURLPROTO_RTMPT = 1 << 20

const CURLPROTO_RTMPE = 1 << 21

const CURLPROTO_RTMPTE = 1 << 22

const CURLPROTO_RTMPS = 1 << 23

const CURLPROTO_RTMPTS = 1 << 24

const CURLPROTO_GOPHER = 1 << 25

const CURLPROTO_SMB = 1 << 26

const CURLPROTO_SMBS = 1 << 27

const CURLPROTO_MQTT = 1 << 28

const CURLPROTO_ALL = ~0

const CURLOPTTYPE_LONG = 0

const CURLOPTTYPE_OBJECTPOINT = 10000

const CURLOPTTYPE_FUNCTIONPOINT = 20000

const CURLOPTTYPE_OFF_T = 30000

const CURLOPTTYPE_BLOB = 40000

const CURLOPTTYPE_STRINGPOINT = CURLOPTTYPE_OBJECTPOINT

const CURLOPTTYPE_SLISTPOINT = CURLOPTTYPE_OBJECTPOINT

const CURLOPTTYPE_CBPOINT = CURLOPTTYPE_OBJECTPOINT

const CURLOPTTYPE_VALUES = CURLOPTTYPE_LONG

const CURLOPT_PROGRESSDATA = CURLOPT_XFERINFODATA

const CURLOPT_SERVER_RESPONSE_TIMEOUT = CURLOPT_FTP_RESPONSE_TIMEOUT

const CURLOPT_POST301 = CURLOPT_POSTREDIR

const CURLOPT_SSLKEYPASSWD = CURLOPT_KEYPASSWD

const CURLOPT_FTPAPPEND = CURLOPT_APPEND

const CURLOPT_FTPLISTONLY = CURLOPT_DIRLISTONLY

const CURLOPT_FTP_SSL = CURLOPT_USE_SSL

const CURLOPT_SSLCERTPASSWD = CURLOPT_KEYPASSWD

const CURLOPT_KRB4LEVEL = CURLOPT_KRBLEVEL

const CURL_IPRESOLVE_WHATEVER = 0

const CURL_IPRESOLVE_V4 = 1

const CURL_IPRESOLVE_V6 = 2

const CURLOPT_RTSPHEADER = CURLOPT_HTTPHEADER

const CURL_HTTP_VERSION_2 = CURL_HTTP_VERSION_2_0

const CURL_REDIR_GET_ALL = 0

const CURL_REDIR_POST_301 = 1

const CURL_REDIR_POST_302 = 2

const CURL_REDIR_POST_303 = 4

const CURL_REDIR_POST_ALL = (CURL_REDIR_POST_301 | CURL_REDIR_POST_302) | CURL_REDIR_POST_303

const CURLINFO_STRING = 0x00100000

const CURLINFO_LONG = 0x00200000

const CURLINFO_DOUBLE = 0x00300000

const CURLINFO_SLIST = 0x00400000

const CURLINFO_PTR = 0x00400000

const CURLINFO_SOCKET = 0x00500000

const CURLINFO_OFF_T = 0x00600000

const CURLINFO_MASK = 0x000fffff

const CURLINFO_TYPEMASK = 0x00f00000

const CURLINFO_HTTP_CODE = CURLINFO_RESPONSE_CODE

const CURL_GLOBAL_SSL = 1 << 0

const CURL_GLOBAL_WIN32 = 1 << 1

const CURL_GLOBAL_ALL = CURL_GLOBAL_SSL | CURL_GLOBAL_WIN32

const CURL_GLOBAL_NOTHING = 0

const CURL_GLOBAL_DEFAULT = CURL_GLOBAL_ALL

const CURL_GLOBAL_ACK_EINTR = 1 << 2

const CURLVERSION_NOW = CURLVERSION_EIGHTH

const CURL_VERSION_IPV6 = 1 << 0

const CURL_VERSION_KERBEROS4 = 1 << 1

const CURL_VERSION_SSL = 1 << 2

const CURL_VERSION_LIBZ = 1 << 3

const CURL_VERSION_NTLM = 1 << 4

const CURL_VERSION_GSSNEGOTIATE = 1 << 5

const CURL_VERSION_DEBUG = 1 << 6

const CURL_VERSION_ASYNCHDNS = 1 << 7

const CURL_VERSION_SPNEGO = 1 << 8

const CURL_VERSION_LARGEFILE = 1 << 9

const CURL_VERSION_IDN = 1 << 10

const CURL_VERSION_SSPI = 1 << 11

const CURL_VERSION_CONV = 1 << 12

const CURL_VERSION_CURLDEBUG = 1 << 13

const CURL_VERSION_TLSAUTH_SRP = 1 << 14

const CURL_VERSION_NTLM_WB = 1 << 15

const CURL_VERSION_HTTP2 = 1 << 16

const CURL_VERSION_GSSAPI = 1 << 17

const CURL_VERSION_KERBEROS5 = 1 << 18

const CURL_VERSION_UNIX_SOCKETS = 1 << 19

const CURL_VERSION_PSL = 1 << 20

const CURL_VERSION_HTTPS_PROXY = 1 << 21

const CURL_VERSION_MULTI_SSL = 1 << 22

const CURL_VERSION_BROTLI = 1 << 23

const CURL_VERSION_ALTSVC = 1 << 24

const CURL_VERSION_HTTP3 = 1 << 25

const CURL_VERSION_ZSTD = 1 << 26

const CURL_VERSION_UNICODE = 1 << 27

const CURLPAUSE_RECV = 1 << 0

const CURLPAUSE_RECV_CONT = 0

const CURLPAUSE_SEND = 1 << 2

const CURLPAUSE_SEND_CONT = 0

const CURLPAUSE_ALL = CURLPAUSE_RECV | CURLPAUSE_SEND

const CURLPAUSE_CONT = CURLPAUSE_RECV_CONT | CURLPAUSE_SEND_CONT

const CURL_BLOB_COPY = 1

const CURL_BLOB_NOCOPY = 0

const CURLM_CALL_MULTI_SOCKET = CURLM_CALL_MULTI_PERFORM

const CURLPIPE_NOTHING = Clong(0)

const CURLPIPE_HTTP1 = Clong(1)

const CURLPIPE_MULTIPLEX = Clong(2)

const CURL_WAIT_POLLIN = 0x0001

const CURL_WAIT_POLLPRI = 0x0002

const CURL_WAIT_POLLOUT = 0x0004

const CURL_POLL_NONE = 0

const CURL_POLL_IN = 1

const CURL_POLL_OUT = 2

const CURL_POLL_INOUT = 3

const CURL_POLL_REMOVE = 4

const CURL_SOCKET_TIMEOUT = CURL_SOCKET_BAD

const CURL_CSELECT_IN = 0x01

const CURL_CSELECT_OUT = 0x02

const CURL_CSELECT_ERR = 0x04

const CURL_PUSH_OK = 0

const CURL_PUSH_DENY = 1

const CURL_PUSH_ERROROUT = 2

const CURLU_DEFAULT_PORT = 1 << 0

const CURLU_NO_DEFAULT_PORT = 1 << 1

const CURLU_DEFAULT_SCHEME = 1 << 2

const CURLU_NON_SUPPORT_SCHEME = 1 << 3

const CURLU_PATH_AS_IS = 1 << 4

const CURLU_DISALLOW_USER = 1 << 5

const CURLU_URLDECODE = 1 << 6

const CURLU_URLENCODE = 1 << 7

const CURLU_APPENDQUERY = 1 << 8

const CURLU_GUESS_SCHEME = 1 << 9

const CURLU_NO_AUTHORITY = 1 << 10

const CURLOT_FLAG_ALIAS = 1 << 0

