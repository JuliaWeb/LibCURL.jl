to_c_type(t::Type{Union{Bool, Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64, Float64, Complex{Float32}, Complex{Float64}}}) = t
to_c_type(t::Type{<:Vector}) = Ptr{to_c_type(eltype(t))}
to_c_type(::Type{String}) = Cstring
to_c_type(::Type{<:Ref}) = Ptr{Cvoid}
to_c_type(t) = t
to_c_type_pairs(va_list) = map(enumerate(to_c_type.(va_list))) do (ind, type)
    :(va_list[$ind]::$type)
end

const __time32_t = Clong

const time_t = __time32_t

const UINT_PTR = Cuint

const u_short = Cushort

const u_int = Cuint

const SOCKET = UINT_PTR

mutable struct fd_set
    fd_count::u_int
    fd_array::NTuple{64, SOCKET}
    fd_set() = new()
end

struct sockaddr
    sa_family::u_short
    sa_data::NTuple{14, Cchar}
end

const socklen_t = Cint

const curl_socklen_t = socklen_t

const curl_off_t = Clonglong

const CURL = Cvoid

const CURLSH = Cvoid

const curl_socket_t = SOCKET

@enum curl_sslbackend::UInt32 begin
    CURLSSLBACKEND_NONE = 0
    CURLSSLBACKEND_OPENSSL = 1
    CURLSSLBACKEND_GNUTLS = 2
    CURLSSLBACKEND_NSS = 3
    CURLSSLBACKEND_OBSOLETE4 = 4
    CURLSSLBACKEND_GSKIT = 5
    CURLSSLBACKEND_POLARSSL = 6
    CURLSSLBACKEND_WOLFSSL = 7
    CURLSSLBACKEND_SCHANNEL = 8
    CURLSSLBACKEND_SECURETRANSPORT = 9
    CURLSSLBACKEND_AXTLS = 10
    CURLSSLBACKEND_MBEDTLS = 11
    CURLSSLBACKEND_MESALINK = 12
    CURLSSLBACKEND_BEARSSL = 13
end

struct curl_httppost
    next::Ptr{curl_httppost}
    name::Ptr{Cchar}
    namelength::Clong
    contents::Ptr{Cchar}
    contentslength::Clong
    buffer::Ptr{Cchar}
    bufferlength::Clong
    contenttype::Ptr{Cchar}
    # contentheader::Ptr{curl_slist}
    contentheader::Ptr{Cvoid}
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

@enum curlfiletype::UInt32 begin
    CURLFILETYPE_FILE = 0
    CURLFILETYPE_DIRECTORY = 1
    CURLFILETYPE_SYMLINK = 2
    CURLFILETYPE_DEVICE_BLOCK = 3
    CURLFILETYPE_DEVICE_CHAR = 4
    CURLFILETYPE_NAMEDPIPE = 5
    CURLFILETYPE_SOCKET = 6
    CURLFILETYPE_DOOR = 7
    CURLFILETYPE_UNKNOWN = 8
end

struct curl_fileinfo
    data::NTuple{72, UInt8}
end

function Base.getproperty(x::Ptr{curl_fileinfo}, f::Symbol)
    f === :filename && return Ptr{Ptr{Cchar}}(x + 0)
    f === :filetype && return Ptr{curlfiletype}(x + 4)
    f === :time && return Ptr{time_t}(x + 8)
    f === :perm && return Ptr{Cuint}(x + 12)
    f === :uid && return Ptr{Cint}(x + 16)
    f === :gid && return Ptr{Cint}(x + 20)
    f === :size && return Ptr{curl_off_t}(x + 24)
    f === :hardlinks && return Ptr{Clong}(x + 32)
    f === :strings && return Ptr{__JL_Ctag_145}(x + 36)
    f === :flags && return Ptr{Cuint}(x + 56)
    f === :b_data && return Ptr{Ptr{Cchar}}(x + 60)
    f === :b_size && return Ptr{Csize_t}(x + 64)
    f === :b_used && return Ptr{Csize_t}(x + 68)
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

@enum curlsocktype::UInt32 begin
    CURLSOCKTYPE_IPCXN = 0
    CURLSOCKTYPE_ACCEPT = 1
    CURLSOCKTYPE_LAST = 2
end

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

@enum curlioerr::UInt32 begin
    CURLIOE_OK = 0
    CURLIOE_UNKNOWNCMD = 1
    CURLIOE_FAILRESTART = 2
    CURLIOE_LAST = 3
end

@enum curliocmd::UInt32 begin
    CURLIOCMD_NOP = 0
    CURLIOCMD_RESTARTREAD = 1
    CURLIOCMD_LAST = 2
end

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

@enum curl_infotype::UInt32 begin
    CURLINFO_TEXT = 0
    CURLINFO_HEADER_IN = 1
    CURLINFO_HEADER_OUT = 2
    CURLINFO_DATA_IN = 3
    CURLINFO_DATA_OUT = 4
    CURLINFO_SSL_DATA_IN = 5
    CURLINFO_SSL_DATA_OUT = 6
    CURLINFO_END = 7
end

# typedef int ( * curl_debug_callback ) ( CURL * handle , /* the handle/transfer this concerns */ curl_infotype type , /* what kind of data */ char * data , /* points to the data */ size_t size , /* size of the data pointed to */ void * userptr )
const curl_debug_callback = Ptr{Cvoid}

@enum CURLcode::UInt32 begin
    CURLE_OK = 0
    CURLE_UNSUPPORTED_PROTOCOL = 1
    CURLE_FAILED_INIT = 2
    CURLE_URL_MALFORMAT = 3
    CURLE_NOT_BUILT_IN = 4
    CURLE_COULDNT_RESOLVE_PROXY = 5
    CURLE_COULDNT_RESOLVE_HOST = 6
    CURLE_COULDNT_CONNECT = 7
    CURLE_WEIRD_SERVER_REPLY = 8
    CURLE_REMOTE_ACCESS_DENIED = 9
    CURLE_FTP_ACCEPT_FAILED = 10
    CURLE_FTP_WEIRD_PASS_REPLY = 11
    CURLE_FTP_ACCEPT_TIMEOUT = 12
    CURLE_FTP_WEIRD_PASV_REPLY = 13
    CURLE_FTP_WEIRD_227_FORMAT = 14
    CURLE_FTP_CANT_GET_HOST = 15
    CURLE_HTTP2 = 16
    CURLE_FTP_COULDNT_SET_TYPE = 17
    CURLE_PARTIAL_FILE = 18
    CURLE_FTP_COULDNT_RETR_FILE = 19
    CURLE_OBSOLETE20 = 20
    CURLE_QUOTE_ERROR = 21
    CURLE_HTTP_RETURNED_ERROR = 22
    CURLE_WRITE_ERROR = 23
    CURLE_OBSOLETE24 = 24
    CURLE_UPLOAD_FAILED = 25
    CURLE_READ_ERROR = 26
    CURLE_OUT_OF_MEMORY = 27
    CURLE_OPERATION_TIMEDOUT = 28
    CURLE_OBSOLETE29 = 29
    CURLE_FTP_PORT_FAILED = 30
    CURLE_FTP_COULDNT_USE_REST = 31
    CURLE_OBSOLETE32 = 32
    CURLE_RANGE_ERROR = 33
    CURLE_HTTP_POST_ERROR = 34
    CURLE_SSL_CONNECT_ERROR = 35
    CURLE_BAD_DOWNLOAD_RESUME = 36
    CURLE_FILE_COULDNT_READ_FILE = 37
    CURLE_LDAP_CANNOT_BIND = 38
    CURLE_LDAP_SEARCH_FAILED = 39
    CURLE_OBSOLETE40 = 40
    CURLE_FUNCTION_NOT_FOUND = 41
    CURLE_ABORTED_BY_CALLBACK = 42
    CURLE_BAD_FUNCTION_ARGUMENT = 43
    CURLE_OBSOLETE44 = 44
    CURLE_INTERFACE_FAILED = 45
    CURLE_OBSOLETE46 = 46
    CURLE_TOO_MANY_REDIRECTS = 47
    CURLE_UNKNOWN_OPTION = 48
    CURLE_TELNET_OPTION_SYNTAX = 49
    CURLE_OBSOLETE50 = 50
    CURLE_OBSOLETE51 = 51
    CURLE_GOT_NOTHING = 52
    CURLE_SSL_ENGINE_NOTFOUND = 53
    CURLE_SSL_ENGINE_SETFAILED = 54
    CURLE_SEND_ERROR = 55
    CURLE_RECV_ERROR = 56
    CURLE_OBSOLETE57 = 57
    CURLE_SSL_CERTPROBLEM = 58
    CURLE_SSL_CIPHER = 59
    CURLE_PEER_FAILED_VERIFICATION = 60
    CURLE_BAD_CONTENT_ENCODING = 61
    CURLE_LDAP_INVALID_URL = 62
    CURLE_FILESIZE_EXCEEDED = 63
    CURLE_USE_SSL_FAILED = 64
    CURLE_SEND_FAIL_REWIND = 65
    CURLE_SSL_ENGINE_INITFAILED = 66
    CURLE_LOGIN_DENIED = 67
    CURLE_TFTP_NOTFOUND = 68
    CURLE_TFTP_PERM = 69
    CURLE_REMOTE_DISK_FULL = 70
    CURLE_TFTP_ILLEGAL = 71
    CURLE_TFTP_UNKNOWNID = 72
    CURLE_REMOTE_FILE_EXISTS = 73
    CURLE_TFTP_NOSUCHUSER = 74
    CURLE_CONV_FAILED = 75
    CURLE_CONV_REQD = 76
    CURLE_SSL_CACERT_BADFILE = 77
    CURLE_REMOTE_FILE_NOT_FOUND = 78
    CURLE_SSH = 79
    CURLE_SSL_SHUTDOWN_FAILED = 80
    CURLE_AGAIN = 81
    CURLE_SSL_CRL_BADFILE = 82
    CURLE_SSL_ISSUER_ERROR = 83
    CURLE_FTP_PRET_FAILED = 84
    CURLE_RTSP_CSEQ_ERROR = 85
    CURLE_RTSP_SESSION_ERROR = 86
    CURLE_FTP_BAD_FILE_LIST = 87
    CURLE_CHUNK_FAILED = 88
    CURLE_NO_CONNECTION_AVAILABLE = 89
    CURLE_SSL_PINNEDPUBKEYNOTMATCH = 90
    CURLE_SSL_INVALIDCERTSTATUS = 91
    CURLE_HTTP2_STREAM = 92
    CURLE_RECURSIVE_API_CALL = 93
    CURLE_AUTH_ERROR = 94
    CURLE_HTTP3 = 95
    CURLE_QUIC_CONNECT_ERROR = 96
    CURLE_PROXY = 97
    CURL_LAST = 98
end

@enum CURLproxycode::UInt32 begin
    CURLPX_OK = 0
    CURLPX_BAD_ADDRESS_TYPE = 1
    CURLPX_BAD_VERSION = 2
    CURLPX_CLOSED = 3
    CURLPX_GSSAPI = 4
    CURLPX_GSSAPI_PERMSG = 5
    CURLPX_GSSAPI_PROTECTION = 6
    CURLPX_IDENTD = 7
    CURLPX_IDENTD_DIFFER = 8
    CURLPX_LONG_HOSTNAME = 9
    CURLPX_LONG_PASSWD = 10
    CURLPX_LONG_USER = 11
    CURLPX_NO_AUTH = 12
    CURLPX_RECV_ADDRESS = 13
    CURLPX_RECV_AUTH = 14
    CURLPX_RECV_CONNECT = 15
    CURLPX_RECV_REQACK = 16
    CURLPX_REPLY_ADDRESS_TYPE_NOT_SUPPORTED = 17
    CURLPX_REPLY_COMMAND_NOT_SUPPORTED = 18
    CURLPX_REPLY_CONNECTION_REFUSED = 19
    CURLPX_REPLY_GENERAL_SERVER_FAILURE = 20
    CURLPX_REPLY_HOST_UNREACHABLE = 21
    CURLPX_REPLY_NETWORK_UNREACHABLE = 22
    CURLPX_REPLY_NOT_ALLOWED = 23
    CURLPX_REPLY_TTL_EXPIRED = 24
    CURLPX_REPLY_UNASSIGNED = 25
    CURLPX_REQUEST_FAILED = 26
    CURLPX_RESOLVE_HOST = 27
    CURLPX_SEND_AUTH = 28
    CURLPX_SEND_CONNECT = 29
    CURLPX_SEND_REQUEST = 30
    CURLPX_UNKNOWN_FAIL = 31
    CURLPX_UNKNOWN_MODE = 32
    CURLPX_USER_REJECTED = 33
    CURLPX_LAST = 34
end

# typedef CURLcode ( * curl_conv_callback ) ( char * buffer , size_t length )
const curl_conv_callback = Ptr{Cvoid}

# typedef CURLcode ( * curl_ssl_ctx_callback ) ( CURL * curl , /* easy handle */ void * ssl_ctx , /* actually an OpenSSL
#                                                            or WolfSSL SSL_CTX,
#                                                            or an mbedTLS
#                                                          mbedtls_ssl_config */ void * userptr )
const curl_ssl_ctx_callback = Ptr{Cvoid}

@enum curl_proxytype::UInt32 begin
    CURLPROXY_HTTP = 0
    CURLPROXY_HTTP_1_0 = 1
    CURLPROXY_HTTPS = 2
    CURLPROXY_SOCKS4 = 4
    CURLPROXY_SOCKS5 = 5
    CURLPROXY_SOCKS4A = 6
    CURLPROXY_SOCKS5_HOSTNAME = 7
end

@enum curl_khtype::UInt32 begin
    CURLKHTYPE_UNKNOWN = 0
    CURLKHTYPE_RSA1 = 1
    CURLKHTYPE_RSA = 2
    CURLKHTYPE_DSS = 3
    CURLKHTYPE_ECDSA = 4
    CURLKHTYPE_ED25519 = 5
end

mutable struct curl_khkey
    key::Ptr{Cchar}
    len::Csize_t
    keytype::curl_khtype
    curl_khkey() = new()
end

@enum curl_khstat::UInt32 begin
    CURLKHSTAT_FINE_ADD_TO_FILE = 0
    CURLKHSTAT_FINE = 1
    CURLKHSTAT_REJECT = 2
    CURLKHSTAT_DEFER = 3
    CURLKHSTAT_FINE_REPLACE = 4
    CURLKHSTAT_LAST = 5
end

@enum curl_khmatch::UInt32 begin
    CURLKHMATCH_OK = 0
    CURLKHMATCH_MISMATCH = 1
    CURLKHMATCH_MISSING = 2
    CURLKHMATCH_LAST = 3
end

# typedef int ( * curl_sshkeycallback ) ( CURL * easy , /* easy handle */ const struct curl_khkey * knownkey , /* known */ const struct curl_khkey * foundkey , /* found */ enum curl_khmatch , /* libcurl's view on the keys */ void * clientp )
const curl_sshkeycallback = Ptr{Cvoid}

@enum curl_usessl::UInt32 begin
    CURLUSESSL_NONE = 0
    CURLUSESSL_TRY = 1
    CURLUSESSL_CONTROL = 2
    CURLUSESSL_ALL = 3
    CURLUSESSL_LAST = 4
end

@enum curl_ftpccc::UInt32 begin
    CURLFTPSSL_CCC_NONE = 0
    CURLFTPSSL_CCC_PASSIVE = 1
    CURLFTPSSL_CCC_ACTIVE = 2
    CURLFTPSSL_CCC_LAST = 3
end

@enum curl_ftpauth::UInt32 begin
    CURLFTPAUTH_DEFAULT = 0
    CURLFTPAUTH_SSL = 1
    CURLFTPAUTH_TLS = 2
    CURLFTPAUTH_LAST = 3
end

@enum curl_ftpcreatedir::UInt32 begin
    CURLFTP_CREATE_DIR_NONE = 0
    CURLFTP_CREATE_DIR = 1
    CURLFTP_CREATE_DIR_RETRY = 2
    CURLFTP_CREATE_DIR_LAST = 3
end

@enum curl_ftpmethod::UInt32 begin
    CURLFTPMETHOD_DEFAULT = 0
    CURLFTPMETHOD_MULTICWD = 1
    CURLFTPMETHOD_NOCWD = 2
    CURLFTPMETHOD_SINGLECWD = 3
    CURLFTPMETHOD_LAST = 4
end

@enum CURLoption::UInt32 begin
    CURLOPT_WRITEDATA = 10001
    CURLOPT_URL = 10002
    CURLOPT_PORT = 3
    CURLOPT_PROXY = 10004
    CURLOPT_USERPWD = 10005
    CURLOPT_PROXYUSERPWD = 10006
    CURLOPT_RANGE = 10007
    CURLOPT_READDATA = 10009
    CURLOPT_ERRORBUFFER = 10010
    CURLOPT_WRITEFUNCTION = 20011
    CURLOPT_READFUNCTION = 20012
    CURLOPT_TIMEOUT = 13
    CURLOPT_INFILESIZE = 14
    CURLOPT_POSTFIELDS = 10015
    CURLOPT_REFERER = 10016
    CURLOPT_FTPPORT = 10017
    CURLOPT_USERAGENT = 10018
    CURLOPT_LOW_SPEED_LIMIT = 19
    CURLOPT_LOW_SPEED_TIME = 20
    CURLOPT_RESUME_FROM = 21
    CURLOPT_COOKIE = 10022
    CURLOPT_HTTPHEADER = 10023
    CURLOPT_HTTPPOST = 10024
    CURLOPT_SSLCERT = 10025
    CURLOPT_KEYPASSWD = 10026
    CURLOPT_CRLF = 27
    CURLOPT_QUOTE = 10028
    CURLOPT_HEADERDATA = 10029
    CURLOPT_COOKIEFILE = 10031
    CURLOPT_SSLVERSION = 32
    CURLOPT_TIMECONDITION = 33
    CURLOPT_TIMEVALUE = 34
    CURLOPT_CUSTOMREQUEST = 10036
    CURLOPT_STDERR = 10037
    CURLOPT_POSTQUOTE = 10039
    CURLOPT_OBSOLETE40 = 10040
    CURLOPT_VERBOSE = 41
    CURLOPT_HEADER = 42
    CURLOPT_NOPROGRESS = 43
    CURLOPT_NOBODY = 44
    CURLOPT_FAILONERROR = 45
    CURLOPT_UPLOAD = 46
    CURLOPT_POST = 47
    CURLOPT_DIRLISTONLY = 48
    CURLOPT_APPEND = 50
    CURLOPT_NETRC = 51
    CURLOPT_FOLLOWLOCATION = 52
    CURLOPT_TRANSFERTEXT = 53
    CURLOPT_PUT = 54
    CURLOPT_PROGRESSFUNCTION = 20056
    CURLOPT_XFERINFODATA = 10057
    CURLOPT_AUTOREFERER = 58
    CURLOPT_PROXYPORT = 59
    CURLOPT_POSTFIELDSIZE = 60
    CURLOPT_HTTPPROXYTUNNEL = 61
    CURLOPT_INTERFACE = 10062
    CURLOPT_KRBLEVEL = 10063
    CURLOPT_SSL_VERIFYPEER = 64
    CURLOPT_CAINFO = 10065
    CURLOPT_MAXREDIRS = 68
    CURLOPT_FILETIME = 69
    CURLOPT_TELNETOPTIONS = 10070
    CURLOPT_MAXCONNECTS = 71
    CURLOPT_OBSOLETE72 = 72
    CURLOPT_FRESH_CONNECT = 74
    CURLOPT_FORBID_REUSE = 75
    CURLOPT_RANDOM_FILE = 10076
    CURLOPT_EGDSOCKET = 10077
    CURLOPT_CONNECTTIMEOUT = 78
    CURLOPT_HEADERFUNCTION = 20079
    CURLOPT_HTTPGET = 80
    CURLOPT_SSL_VERIFYHOST = 81
    CURLOPT_COOKIEJAR = 10082
    CURLOPT_SSL_CIPHER_LIST = 10083
    CURLOPT_HTTP_VERSION = 84
    CURLOPT_FTP_USE_EPSV = 85
    CURLOPT_SSLCERTTYPE = 10086
    CURLOPT_SSLKEY = 10087
    CURLOPT_SSLKEYTYPE = 10088
    CURLOPT_SSLENGINE = 10089
    CURLOPT_SSLENGINE_DEFAULT = 90
    CURLOPT_DNS_USE_GLOBAL_CACHE = 91
    CURLOPT_DNS_CACHE_TIMEOUT = 92
    CURLOPT_PREQUOTE = 10093
    CURLOPT_DEBUGFUNCTION = 20094
    CURLOPT_DEBUGDATA = 10095
    CURLOPT_COOKIESESSION = 96
    CURLOPT_CAPATH = 10097
    CURLOPT_BUFFERSIZE = 98
    CURLOPT_NOSIGNAL = 99
    CURLOPT_SHARE = 10100
    CURLOPT_PROXYTYPE = 101
    CURLOPT_ACCEPT_ENCODING = 10102
    CURLOPT_PRIVATE = 10103
    CURLOPT_HTTP200ALIASES = 10104
    CURLOPT_UNRESTRICTED_AUTH = 105
    CURLOPT_FTP_USE_EPRT = 106
    CURLOPT_HTTPAUTH = 107
    CURLOPT_SSL_CTX_FUNCTION = 20108
    CURLOPT_SSL_CTX_DATA = 10109
    CURLOPT_FTP_CREATE_MISSING_DIRS = 110
    CURLOPT_PROXYAUTH = 111
    CURLOPT_FTP_RESPONSE_TIMEOUT = 112
    CURLOPT_IPRESOLVE = 113
    CURLOPT_MAXFILESIZE = 114
    CURLOPT_INFILESIZE_LARGE = 30115
    CURLOPT_RESUME_FROM_LARGE = 30116
    CURLOPT_MAXFILESIZE_LARGE = 30117
    CURLOPT_NETRC_FILE = 10118
    CURLOPT_USE_SSL = 119
    CURLOPT_POSTFIELDSIZE_LARGE = 30120
    CURLOPT_TCP_NODELAY = 121
    CURLOPT_FTPSSLAUTH = 129
    CURLOPT_IOCTLFUNCTION = 20130
    CURLOPT_IOCTLDATA = 10131
    CURLOPT_FTP_ACCOUNT = 10134
    CURLOPT_COOKIELIST = 10135
    CURLOPT_IGNORE_CONTENT_LENGTH = 136
    CURLOPT_FTP_SKIP_PASV_IP = 137
    CURLOPT_FTP_FILEMETHOD = 138
    CURLOPT_LOCALPORT = 139
    CURLOPT_LOCALPORTRANGE = 140
    CURLOPT_CONNECT_ONLY = 141
    CURLOPT_CONV_FROM_NETWORK_FUNCTION = 20142
    CURLOPT_CONV_TO_NETWORK_FUNCTION = 20143
    CURLOPT_CONV_FROM_UTF8_FUNCTION = 20144
    CURLOPT_MAX_SEND_SPEED_LARGE = 30145
    CURLOPT_MAX_RECV_SPEED_LARGE = 30146
    CURLOPT_FTP_ALTERNATIVE_TO_USER = 10147
    CURLOPT_SOCKOPTFUNCTION = 20148
    CURLOPT_SOCKOPTDATA = 10149
    CURLOPT_SSL_SESSIONID_CACHE = 150
    CURLOPT_SSH_AUTH_TYPES = 151
    CURLOPT_SSH_PUBLIC_KEYFILE = 10152
    CURLOPT_SSH_PRIVATE_KEYFILE = 10153
    CURLOPT_FTP_SSL_CCC = 154
    CURLOPT_TIMEOUT_MS = 155
    CURLOPT_CONNECTTIMEOUT_MS = 156
    CURLOPT_HTTP_TRANSFER_DECODING = 157
    CURLOPT_HTTP_CONTENT_DECODING = 158
    CURLOPT_NEW_FILE_PERMS = 159
    CURLOPT_NEW_DIRECTORY_PERMS = 160
    CURLOPT_POSTREDIR = 161
    CURLOPT_SSH_HOST_PUBLIC_KEY_MD5 = 10162
    CURLOPT_OPENSOCKETFUNCTION = 20163
    CURLOPT_OPENSOCKETDATA = 10164
    CURLOPT_COPYPOSTFIELDS = 10165
    CURLOPT_PROXY_TRANSFER_MODE = 166
    CURLOPT_SEEKFUNCTION = 20167
    CURLOPT_SEEKDATA = 10168
    CURLOPT_CRLFILE = 10169
    CURLOPT_ISSUERCERT = 10170
    CURLOPT_ADDRESS_SCOPE = 171
    CURLOPT_CERTINFO = 172
    CURLOPT_USERNAME = 10173
    CURLOPT_PASSWORD = 10174
    CURLOPT_PROXYUSERNAME = 10175
    CURLOPT_PROXYPASSWORD = 10176
    CURLOPT_NOPROXY = 10177
    CURLOPT_TFTP_BLKSIZE = 178
    CURLOPT_SOCKS5_GSSAPI_SERVICE = 10179
    CURLOPT_SOCKS5_GSSAPI_NEC = 180
    CURLOPT_PROTOCOLS = 181
    CURLOPT_REDIR_PROTOCOLS = 182
    CURLOPT_SSH_KNOWNHOSTS = 10183
    CURLOPT_SSH_KEYFUNCTION = 20184
    CURLOPT_SSH_KEYDATA = 10185
    CURLOPT_MAIL_FROM = 10186
    CURLOPT_MAIL_RCPT = 10187
    CURLOPT_FTP_USE_PRET = 188
    CURLOPT_RTSP_REQUEST = 189
    CURLOPT_RTSP_SESSION_ID = 10190
    CURLOPT_RTSP_STREAM_URI = 10191
    CURLOPT_RTSP_TRANSPORT = 10192
    CURLOPT_RTSP_CLIENT_CSEQ = 193
    CURLOPT_RTSP_SERVER_CSEQ = 194
    CURLOPT_INTERLEAVEDATA = 10195
    CURLOPT_INTERLEAVEFUNCTION = 20196
    CURLOPT_WILDCARDMATCH = 197
    CURLOPT_CHUNK_BGN_FUNCTION = 20198
    CURLOPT_CHUNK_END_FUNCTION = 20199
    CURLOPT_FNMATCH_FUNCTION = 20200
    CURLOPT_CHUNK_DATA = 10201
    CURLOPT_FNMATCH_DATA = 10202
    CURLOPT_RESOLVE = 10203
    CURLOPT_TLSAUTH_USERNAME = 10204
    CURLOPT_TLSAUTH_PASSWORD = 10205
    CURLOPT_TLSAUTH_TYPE = 10206
    CURLOPT_TRANSFER_ENCODING = 207
    CURLOPT_CLOSESOCKETFUNCTION = 20208
    CURLOPT_CLOSESOCKETDATA = 10209
    CURLOPT_GSSAPI_DELEGATION = 210
    CURLOPT_DNS_SERVERS = 10211
    CURLOPT_ACCEPTTIMEOUT_MS = 212
    CURLOPT_TCP_KEEPALIVE = 213
    CURLOPT_TCP_KEEPIDLE = 214
    CURLOPT_TCP_KEEPINTVL = 215
    CURLOPT_SSL_OPTIONS = 216
    CURLOPT_MAIL_AUTH = 10217
    CURLOPT_SASL_IR = 218
    CURLOPT_XFERINFOFUNCTION = 20219
    CURLOPT_XOAUTH2_BEARER = 10220
    CURLOPT_DNS_INTERFACE = 10221
    CURLOPT_DNS_LOCAL_IP4 = 10222
    CURLOPT_DNS_LOCAL_IP6 = 10223
    CURLOPT_LOGIN_OPTIONS = 10224
    CURLOPT_SSL_ENABLE_NPN = 225
    CURLOPT_SSL_ENABLE_ALPN = 226
    CURLOPT_EXPECT_100_TIMEOUT_MS = 227
    CURLOPT_PROXYHEADER = 10228
    CURLOPT_HEADEROPT = 229
    CURLOPT_PINNEDPUBLICKEY = 10230
    CURLOPT_UNIX_SOCKET_PATH = 10231
    CURLOPT_SSL_VERIFYSTATUS = 232
    CURLOPT_SSL_FALSESTART = 233
    CURLOPT_PATH_AS_IS = 234
    CURLOPT_PROXY_SERVICE_NAME = 10235
    CURLOPT_SERVICE_NAME = 10236
    CURLOPT_PIPEWAIT = 237
    CURLOPT_DEFAULT_PROTOCOL = 10238
    CURLOPT_STREAM_WEIGHT = 239
    CURLOPT_STREAM_DEPENDS = 10240
    CURLOPT_STREAM_DEPENDS_E = 10241
    CURLOPT_TFTP_NO_OPTIONS = 242
    CURLOPT_CONNECT_TO = 10243
    CURLOPT_TCP_FASTOPEN = 244
    CURLOPT_KEEP_SENDING_ON_ERROR = 245
    CURLOPT_PROXY_CAINFO = 10246
    CURLOPT_PROXY_CAPATH = 10247
    CURLOPT_PROXY_SSL_VERIFYPEER = 248
    CURLOPT_PROXY_SSL_VERIFYHOST = 249
    CURLOPT_PROXY_SSLVERSION = 250
    CURLOPT_PROXY_TLSAUTH_USERNAME = 10251
    CURLOPT_PROXY_TLSAUTH_PASSWORD = 10252
    CURLOPT_PROXY_TLSAUTH_TYPE = 10253
    CURLOPT_PROXY_SSLCERT = 10254
    CURLOPT_PROXY_SSLCERTTYPE = 10255
    CURLOPT_PROXY_SSLKEY = 10256
    CURLOPT_PROXY_SSLKEYTYPE = 10257
    CURLOPT_PROXY_KEYPASSWD = 10258
    CURLOPT_PROXY_SSL_CIPHER_LIST = 10259
    CURLOPT_PROXY_CRLFILE = 10260
    CURLOPT_PROXY_SSL_OPTIONS = 261
    CURLOPT_PRE_PROXY = 10262
    CURLOPT_PROXY_PINNEDPUBLICKEY = 10263
    CURLOPT_ABSTRACT_UNIX_SOCKET = 10264
    CURLOPT_SUPPRESS_CONNECT_HEADERS = 265
    CURLOPT_REQUEST_TARGET = 10266
    CURLOPT_SOCKS5_AUTH = 267
    CURLOPT_SSH_COMPRESSION = 268
    CURLOPT_MIMEPOST = 10269
    CURLOPT_TIMEVALUE_LARGE = 30270
    CURLOPT_HAPPY_EYEBALLS_TIMEOUT_MS = 271
    CURLOPT_RESOLVER_START_FUNCTION = 20272
    CURLOPT_RESOLVER_START_DATA = 10273
    CURLOPT_HAPROXYPROTOCOL = 274
    CURLOPT_DNS_SHUFFLE_ADDRESSES = 275
    CURLOPT_TLS13_CIPHERS = 10276
    CURLOPT_PROXY_TLS13_CIPHERS = 10277
    CURLOPT_DISALLOW_USERNAME_IN_URL = 278
    CURLOPT_DOH_URL = 10279
    CURLOPT_UPLOAD_BUFFERSIZE = 280
    CURLOPT_UPKEEP_INTERVAL_MS = 281
    CURLOPT_CURLU = 10282
    CURLOPT_TRAILERFUNCTION = 20283
    CURLOPT_TRAILERDATA = 10284
    CURLOPT_HTTP09_ALLOWED = 285
    CURLOPT_ALTSVC_CTRL = 286
    CURLOPT_ALTSVC = 10287
    CURLOPT_MAXAGE_CONN = 288
    CURLOPT_SASL_AUTHZID = 10289
    CURLOPT_MAIL_RCPT_ALLLOWFAILS = 290
    CURLOPT_SSLCERT_BLOB = 40291
    CURLOPT_SSLKEY_BLOB = 40292
    CURLOPT_PROXY_SSLCERT_BLOB = 40293
    CURLOPT_PROXY_SSLKEY_BLOB = 40294
    CURLOPT_ISSUERCERT_BLOB = 40295
    CURLOPT_PROXY_ISSUERCERT = 10296
    CURLOPT_PROXY_ISSUERCERT_BLOB = 40297
    CURLOPT_SSL_EC_CURVES = 10298
    CURLOPT_LASTENTRY = 10299
end

@enum __JL_Ctag_123::UInt32 begin
    CURL_HTTP_VERSION_NONE = 0
    CURL_HTTP_VERSION_1_0 = 1
    CURL_HTTP_VERSION_1_1 = 2
    CURL_HTTP_VERSION_2_0 = 3
    CURL_HTTP_VERSION_2TLS = 4
    CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE = 5
    CURL_HTTP_VERSION_3 = 30
    CURL_HTTP_VERSION_LAST = 31
end

@enum __JL_Ctag_124::UInt32 begin
    CURL_RTSPREQ_NONE = 0
    CURL_RTSPREQ_OPTIONS = 1
    CURL_RTSPREQ_DESCRIBE = 2
    CURL_RTSPREQ_ANNOUNCE = 3
    CURL_RTSPREQ_SETUP = 4
    CURL_RTSPREQ_PLAY = 5
    CURL_RTSPREQ_PAUSE = 6
    CURL_RTSPREQ_TEARDOWN = 7
    CURL_RTSPREQ_GET_PARAMETER = 8
    CURL_RTSPREQ_SET_PARAMETER = 9
    CURL_RTSPREQ_RECORD = 10
    CURL_RTSPREQ_RECEIVE = 11
    CURL_RTSPREQ_LAST = 12
end

@enum CURL_NETRC_OPTION::UInt32 begin
    CURL_NETRC_IGNORED = 0
    CURL_NETRC_OPTIONAL = 1
    CURL_NETRC_REQUIRED = 2
    CURL_NETRC_LAST = 3
end

@enum __JL_Ctag_125::UInt32 begin
    CURL_SSLVERSION_DEFAULT = 0
    CURL_SSLVERSION_TLSv1 = 1
    CURL_SSLVERSION_SSLv2 = 2
    CURL_SSLVERSION_SSLv3 = 3
    CURL_SSLVERSION_TLSv1_0 = 4
    CURL_SSLVERSION_TLSv1_1 = 5
    CURL_SSLVERSION_TLSv1_2 = 6
    CURL_SSLVERSION_TLSv1_3 = 7
    CURL_SSLVERSION_LAST = 8
end

@enum __JL_Ctag_126::UInt32 begin
    CURL_SSLVERSION_MAX_NONE = 0
    CURL_SSLVERSION_MAX_DEFAULT = 65536
    CURL_SSLVERSION_MAX_TLSv1_0 = 262144
    CURL_SSLVERSION_MAX_TLSv1_1 = 327680
    CURL_SSLVERSION_MAX_TLSv1_2 = 393216
    CURL_SSLVERSION_MAX_TLSv1_3 = 458752
    CURL_SSLVERSION_MAX_LAST = 524288
end

@enum CURL_TLSAUTH::UInt32 begin
    CURL_TLSAUTH_NONE = 0
    CURL_TLSAUTH_SRP = 1
    CURL_TLSAUTH_LAST = 2
end

@enum curl_TimeCond::UInt32 begin
    CURL_TIMECOND_NONE = 0
    CURL_TIMECOND_IFMODSINCE = 1
    CURL_TIMECOND_IFUNMODSINCE = 2
    CURL_TIMECOND_LASTMOD = 3
    CURL_TIMECOND_LAST = 4
end

function curl_strequal(s1, s2)
    ccall((:curl_strequal, libcurl), Cint, (Ptr{Cchar}, Ptr{Cchar}), s1, s2)
end

function curl_strnequal(s1, s2, n)
    ccall((:curl_strnequal, libcurl), Cint, (Ptr{Cchar}, Ptr{Cchar}, Csize_t), s1, s2, n)
end

mutable struct curl_mime end

mutable struct curl_mimepart end

function curl_mime_init(easy)
    ccall((:curl_mime_init, libcurl), Ptr{curl_mime}, (Ptr{CURL},), easy)
end

function curl_mime_free(mime)
    ccall((:curl_mime_free, libcurl), Cvoid, (Ptr{curl_mime},), mime)
end

function curl_mime_addpart(mime)
    ccall((:curl_mime_addpart, libcurl), Ptr{curl_mimepart}, (Ptr{curl_mime},), mime)
end

function curl_mime_name(part, name)
    ccall((:curl_mime_name, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{Cchar}), part, name)
end

function curl_mime_filename(part, filename)
    ccall((:curl_mime_filename, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{Cchar}), part, filename)
end

function curl_mime_type(part, mimetype)
    ccall((:curl_mime_type, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{Cchar}), part, mimetype)
end

function curl_mime_encoder(part, encoding)
    ccall((:curl_mime_encoder, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{Cchar}), part, encoding)
end

function curl_mime_data(part, data, datasize)
    ccall((:curl_mime_data, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{Cchar}, Csize_t), part, data, datasize)
end

function curl_mime_filedata(part, filename)
    ccall((:curl_mime_filedata, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{Cchar}), part, filename)
end

function curl_mime_data_cb(part, datasize, readfunc, seekfunc, freefunc, arg)
    ccall((:curl_mime_data_cb, libcurl), CURLcode, (Ptr{curl_mimepart}, curl_off_t, curl_read_callback, curl_seek_callback, curl_free_callback, Ptr{Cvoid}), part, datasize, readfunc, seekfunc, freefunc, arg)
end

function curl_mime_subparts(part, subparts)
    ccall((:curl_mime_subparts, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{curl_mime}), part, subparts)
end

struct curl_slist
    data::Ptr{Cchar}
    next::Ptr{curl_slist}
end

function curl_mime_headers(part, headers, take_ownership)
    ccall((:curl_mime_headers, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{curl_slist}, Cint), part, headers, take_ownership)
end

@enum CURLformoption::UInt32 begin
    CURLFORM_NOTHING = 0
    CURLFORM_COPYNAME = 1
    CURLFORM_PTRNAME = 2
    CURLFORM_NAMELENGTH = 3
    CURLFORM_COPYCONTENTS = 4
    CURLFORM_PTRCONTENTS = 5
    CURLFORM_CONTENTSLENGTH = 6
    CURLFORM_FILECONTENT = 7
    CURLFORM_ARRAY = 8
    CURLFORM_OBSOLETE = 9
    CURLFORM_FILE = 10
    CURLFORM_BUFFER = 11
    CURLFORM_BUFFERPTR = 12
    CURLFORM_BUFFERLENGTH = 13
    CURLFORM_CONTENTTYPE = 14
    CURLFORM_CONTENTHEADER = 15
    CURLFORM_FILENAME = 16
    CURLFORM_END = 17
    CURLFORM_OBSOLETE2 = 18
    CURLFORM_STREAM = 19
    CURLFORM_CONTENTLEN = 20
    CURLFORM_LASTENTRY = 21
end

mutable struct curl_forms
    option::CURLformoption
    value::Ptr{Cchar}
    curl_forms() = new()
end

@enum CURLFORMcode::UInt32 begin
    CURL_FORMADD_OK = 0
    CURL_FORMADD_MEMORY = 1
    CURL_FORMADD_OPTION_TWICE = 2
    CURL_FORMADD_NULL = 3
    CURL_FORMADD_UNKNOWN_OPTION = 4
    CURL_FORMADD_INCOMPLETE = 5
    CURL_FORMADD_ILLEGAL_ARRAY = 6
    CURL_FORMADD_DISABLED = 7
    CURL_FORMADD_LAST = 8
end

# automatic type deduction for variadic arguments may not be what you want, please use with caution
@generated function curl_formadd(httppost, last_post, va_list...)
        :(@ccall(libcurl.curl_formadd(httppost::Ptr{Ptr{curl_httppost}}, last_post::Ptr{Ptr{curl_httppost}}; $(to_c_type_pairs(va_list)...))::CURLFORMcode))
    end

# typedef size_t ( * curl_formget_callback ) ( void * arg , const char * buf , size_t len )
const curl_formget_callback = Ptr{Cvoid}

function curl_formget(form, arg, append)
    ccall((:curl_formget, libcurl), Cint, (Ptr{curl_httppost}, Ptr{Cvoid}, curl_formget_callback), form, arg, append)
end

function curl_formfree(form)
    ccall((:curl_formfree, libcurl), Cvoid, (Ptr{curl_httppost},), form)
end

function curl_getenv(variable)
    ccall((:curl_getenv, libcurl), Ptr{Cchar}, (Ptr{Cchar},), variable)
end

function curl_version()
    ccall((:curl_version, libcurl), Ptr{Cchar}, ())
end

function curl_easy_escape(handle, string, length)
    ccall((:curl_easy_escape, libcurl), Ptr{Cchar}, (Ptr{CURL}, Ptr{Cchar}, Cint), handle, string, length)
end

function curl_escape(string, length)
    ccall((:curl_escape, libcurl), Ptr{Cchar}, (Ptr{Cchar}, Cint), string, length)
end

function curl_easy_unescape(handle, string, length, outlength)
    ccall((:curl_easy_unescape, libcurl), Ptr{Cchar}, (Ptr{CURL}, Ptr{Cchar}, Cint, Ptr{Cint}), handle, string, length, outlength)
end

function curl_unescape(string, length)
    ccall((:curl_unescape, libcurl), Ptr{Cchar}, (Ptr{Cchar}, Cint), string, length)
end

function curl_free(p)
    ccall((:curl_free, libcurl), Cvoid, (Ptr{Cvoid},), p)
end

function curl_global_init(flags)
    ccall((:curl_global_init, libcurl), CURLcode, (Clong,), flags)
end

function curl_global_init_mem(flags, m, f, r, s, c)
    ccall((:curl_global_init_mem, libcurl), CURLcode, (Clong, curl_malloc_callback, curl_free_callback, curl_realloc_callback, curl_strdup_callback, curl_calloc_callback), flags, m, f, r, s, c)
end

function curl_global_cleanup()
    ccall((:curl_global_cleanup, libcurl), Cvoid, ())
end

mutable struct curl_ssl_backend
    id::curl_sslbackend
    name::Ptr{Cchar}
    curl_ssl_backend() = new()
end

@enum CURLsslset::UInt32 begin
    CURLSSLSET_OK = 0
    CURLSSLSET_UNKNOWN_BACKEND = 1
    CURLSSLSET_TOO_LATE = 2
    CURLSSLSET_NO_BACKENDS = 3
end

function curl_global_sslset(id, name, avail)
    ccall((:curl_global_sslset, libcurl), CURLsslset, (curl_sslbackend, Ptr{Cchar}, Ptr{Ptr{Ptr{curl_ssl_backend}}}), id, name, avail)
end

function curl_slist_append(arg1, arg2)
    ccall((:curl_slist_append, libcurl), Ptr{curl_slist}, (Ptr{curl_slist}, Ptr{Cchar}), arg1, arg2)
end

function curl_slist_free_all(arg1)
    ccall((:curl_slist_free_all, libcurl), Cvoid, (Ptr{curl_slist},), arg1)
end

function curl_getdate(p, unused)
    ccall((:curl_getdate, libcurl), time_t, (Ptr{Cchar}, Ptr{time_t}), p, unused)
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

@enum CURLINFO::UInt32 begin
    CURLINFO_NONE = 0
    CURLINFO_EFFECTIVE_URL = 1048577
    CURLINFO_RESPONSE_CODE = 2097154
    CURLINFO_TOTAL_TIME = 3145731
    CURLINFO_NAMELOOKUP_TIME = 3145732
    CURLINFO_CONNECT_TIME = 3145733
    CURLINFO_PRETRANSFER_TIME = 3145734
    CURLINFO_SIZE_UPLOAD = 3145735
    CURLINFO_SIZE_UPLOAD_T = 6291463
    CURLINFO_SIZE_DOWNLOAD = 3145736
    CURLINFO_SIZE_DOWNLOAD_T = 6291464
    CURLINFO_SPEED_DOWNLOAD = 3145737
    CURLINFO_SPEED_DOWNLOAD_T = 6291465
    CURLINFO_SPEED_UPLOAD = 3145738
    CURLINFO_SPEED_UPLOAD_T = 6291466
    CURLINFO_HEADER_SIZE = 2097163
    CURLINFO_REQUEST_SIZE = 2097164
    CURLINFO_SSL_VERIFYRESULT = 2097165
    CURLINFO_FILETIME = 2097166
    CURLINFO_FILETIME_T = 6291470
    CURLINFO_CONTENT_LENGTH_DOWNLOAD = 3145743
    CURLINFO_CONTENT_LENGTH_DOWNLOAD_T = 6291471
    CURLINFO_CONTENT_LENGTH_UPLOAD = 3145744
    CURLINFO_CONTENT_LENGTH_UPLOAD_T = 6291472
    CURLINFO_STARTTRANSFER_TIME = 3145745
    CURLINFO_CONTENT_TYPE = 1048594
    CURLINFO_REDIRECT_TIME = 3145747
    CURLINFO_REDIRECT_COUNT = 2097172
    CURLINFO_PRIVATE = 1048597
    CURLINFO_HTTP_CONNECTCODE = 2097174
    CURLINFO_HTTPAUTH_AVAIL = 2097175
    CURLINFO_PROXYAUTH_AVAIL = 2097176
    CURLINFO_OS_ERRNO = 2097177
    CURLINFO_NUM_CONNECTS = 2097178
    CURLINFO_SSL_ENGINES = 4194331
    CURLINFO_COOKIELIST = 4194332
    CURLINFO_LASTSOCKET = 2097181
    CURLINFO_FTP_ENTRY_PATH = 1048606
    CURLINFO_REDIRECT_URL = 1048607
    CURLINFO_PRIMARY_IP = 1048608
    CURLINFO_APPCONNECT_TIME = 3145761
    CURLINFO_CERTINFO = 4194338
    CURLINFO_CONDITION_UNMET = 2097187
    CURLINFO_RTSP_SESSION_ID = 1048612
    CURLINFO_RTSP_CLIENT_CSEQ = 2097189
    CURLINFO_RTSP_SERVER_CSEQ = 2097190
    CURLINFO_RTSP_CSEQ_RECV = 2097191
    CURLINFO_PRIMARY_PORT = 2097192
    CURLINFO_LOCAL_IP = 1048617
    CURLINFO_LOCAL_PORT = 2097194
    CURLINFO_TLS_SESSION = 4194347
    CURLINFO_ACTIVESOCKET = 5242924
    CURLINFO_TLS_SSL_PTR = 4194349
    CURLINFO_HTTP_VERSION = 2097198
    CURLINFO_PROXY_SSL_VERIFYRESULT = 2097199
    CURLINFO_PROTOCOL = 2097200
    CURLINFO_SCHEME = 1048625
    CURLINFO_TOTAL_TIME_T = 6291506
    CURLINFO_NAMELOOKUP_TIME_T = 6291507
    CURLINFO_CONNECT_TIME_T = 6291508
    CURLINFO_PRETRANSFER_TIME_T = 6291509
    CURLINFO_STARTTRANSFER_TIME_T = 6291510
    CURLINFO_REDIRECT_TIME_T = 6291511
    CURLINFO_APPCONNECT_TIME_T = 6291512
    CURLINFO_RETRY_AFTER = 6291513
    CURLINFO_EFFECTIVE_METHOD = 1048634
    CURLINFO_PROXY_ERROR = 2097211
    CURLINFO_LASTONE = 59
end

@enum curl_closepolicy::UInt32 begin
    CURLCLOSEPOLICY_NONE = 0
    CURLCLOSEPOLICY_OLDEST = 1
    CURLCLOSEPOLICY_LEAST_RECENTLY_USED = 2
    CURLCLOSEPOLICY_LEAST_TRAFFIC = 3
    CURLCLOSEPOLICY_SLOWEST = 4
    CURLCLOSEPOLICY_CALLBACK = 5
    CURLCLOSEPOLICY_LAST = 6
end

@enum curl_lock_data::UInt32 begin
    CURL_LOCK_DATA_NONE = 0
    CURL_LOCK_DATA_SHARE = 1
    CURL_LOCK_DATA_COOKIE = 2
    CURL_LOCK_DATA_DNS = 3
    CURL_LOCK_DATA_SSL_SESSION = 4
    CURL_LOCK_DATA_CONNECT = 5
    CURL_LOCK_DATA_PSL = 6
    CURL_LOCK_DATA_LAST = 7
end

@enum curl_lock_access::UInt32 begin
    CURL_LOCK_ACCESS_NONE = 0
    CURL_LOCK_ACCESS_SHARED = 1
    CURL_LOCK_ACCESS_SINGLE = 2
    CURL_LOCK_ACCESS_LAST = 3
end

# typedef void ( * curl_lock_function ) ( CURL * handle , curl_lock_data data , curl_lock_access locktype , void * userptr )
const curl_lock_function = Ptr{Cvoid}

# typedef void ( * curl_unlock_function ) ( CURL * handle , curl_lock_data data , void * userptr )
const curl_unlock_function = Ptr{Cvoid}

@enum CURLSHcode::UInt32 begin
    CURLSHE_OK = 0
    CURLSHE_BAD_OPTION = 1
    CURLSHE_IN_USE = 2
    CURLSHE_INVALID = 3
    CURLSHE_NOMEM = 4
    CURLSHE_NOT_BUILT_IN = 5
    CURLSHE_LAST = 6
end

@enum CURLSHoption::UInt32 begin
    CURLSHOPT_NONE = 0
    CURLSHOPT_SHARE = 1
    CURLSHOPT_UNSHARE = 2
    CURLSHOPT_LOCKFUNC = 3
    CURLSHOPT_UNLOCKFUNC = 4
    CURLSHOPT_USERDATA = 5
    CURLSHOPT_LAST = 6
end

function curl_share_init()
    ccall((:curl_share_init, libcurl), Ptr{CURLSH}, ())
end

# automatic type deduction for variadic arguments may not be what you want, please use with caution
@generated function curl_share_setopt(arg1, option, va_list...)
        :(@ccall(libcurl.curl_share_setopt(arg1::Ptr{CURLSH}, option::CURLSHoption; $(to_c_type_pairs(va_list)...))::CURLSHcode))
    end

function curl_share_cleanup(arg1)
    ccall((:curl_share_cleanup, libcurl), CURLSHcode, (Ptr{CURLSH},), arg1)
end

@enum CURLversion::UInt32 begin
    CURLVERSION_FIRST = 0
    CURLVERSION_SECOND = 1
    CURLVERSION_THIRD = 2
    CURLVERSION_FOURTH = 3
    CURLVERSION_FIFTH = 4
    CURLVERSION_SIXTH = 5
    CURLVERSION_SEVENTH = 6
    CURLVERSION_EIGHTH = 7
    CURLVERSION_LAST = 8
end

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
    ccall((:curl_version_info, libcurl), Ptr{curl_version_info_data}, (CURLversion,), arg1)
end

function curl_easy_strerror(arg1)
    ccall((:curl_easy_strerror, libcurl), Ptr{Cchar}, (CURLcode,), arg1)
end

function curl_share_strerror(arg1)
    ccall((:curl_share_strerror, libcurl), Ptr{Cchar}, (CURLSHcode,), arg1)
end

function curl_easy_pause(handle, bitmask)
    ccall((:curl_easy_pause, libcurl), CURLcode, (Ptr{CURL}, Cint), handle, bitmask)
end

mutable struct curl_blob
    data::Ptr{Cvoid}
    len::Csize_t
    flags::Cuint
    curl_blob() = new()
end

function curl_easy_init()
    ccall((:curl_easy_init, libcurl), Ptr{CURL}, ())
end

# automatic type deduction for variadic arguments may not be what you want, please use with caution
@generated function curl_easy_setopt(curl, option, va_list...)
        :(@ccall(libcurl.curl_easy_setopt(curl::Ptr{CURL}, option::CURLoption; $(to_c_type_pairs(va_list)...))::CURLcode))
    end

function curl_easy_perform(curl)
    ccall((:curl_easy_perform, libcurl), CURLcode, (Ptr{CURL},), curl)
end

function curl_easy_cleanup(curl)
    ccall((:curl_easy_cleanup, libcurl), Cvoid, (Ptr{CURL},), curl)
end

# automatic type deduction for variadic arguments may not be what you want, please use with caution
@generated function curl_easy_getinfo(curl, info, va_list...)
        :(@ccall(libcurl.curl_easy_getinfo(curl::Ptr{CURL}, info::CURLINFO; $(to_c_type_pairs(va_list)...))::CURLcode))
    end

function curl_easy_duphandle(curl)
    ccall((:curl_easy_duphandle, libcurl), Ptr{CURL}, (Ptr{CURL},), curl)
end

function curl_easy_reset(curl)
    ccall((:curl_easy_reset, libcurl), Cvoid, (Ptr{CURL},), curl)
end

function curl_easy_recv(curl, buffer, buflen, n)
    ccall((:curl_easy_recv, libcurl), CURLcode, (Ptr{CURL}, Ptr{Cvoid}, Csize_t, Ptr{Csize_t}), curl, buffer, buflen, n)
end

function curl_easy_send(curl, buffer, buflen, n)
    ccall((:curl_easy_send, libcurl), CURLcode, (Ptr{CURL}, Ptr{Cvoid}, Csize_t, Ptr{Csize_t}), curl, buffer, buflen, n)
end

function curl_easy_upkeep(curl)
    ccall((:curl_easy_upkeep, libcurl), CURLcode, (Ptr{CURL},), curl)
end

const CURLM = Cvoid

@enum CURLMcode::Int32 begin
    CURLM_CALL_MULTI_PERFORM = -1
    CURLM_OK = 0
    CURLM_BAD_HANDLE = 1
    CURLM_BAD_EASY_HANDLE = 2
    CURLM_OUT_OF_MEMORY = 3
    CURLM_INTERNAL_ERROR = 4
    CURLM_BAD_SOCKET = 5
    CURLM_UNKNOWN_OPTION = 6
    CURLM_ADDED_ALREADY = 7
    CURLM_RECURSIVE_API_CALL = 8
    CURLM_WAKEUP_FAILURE = 9
    CURLM_BAD_FUNCTION_ARGUMENT = 10
    CURLM_LAST = 11
end

@enum CURLMSG::UInt32 begin
    CURLMSG_NONE = 0
    CURLMSG_DONE = 1
    CURLMSG_LAST = 2
end

struct CURLMsg
    data::NTuple{12, UInt8}
end

function Base.getproperty(x::Ptr{CURLMsg}, f::Symbol)
    f === :msg && return Ptr{CURLMSG}(x + 0)
    f === :easy_handle && return Ptr{Ptr{CURL}}(x + 4)
    f === :data && return Ptr{__JL_Ctag_144}(x + 8)
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
    ccall((:curl_multi_init, libcurl), Ptr{CURLM}, ())
end

function curl_multi_add_handle(multi_handle, curl_handle)
    ccall((:curl_multi_add_handle, libcurl), CURLMcode, (Ptr{CURLM}, Ptr{CURL}), multi_handle, curl_handle)
end

function curl_multi_remove_handle(multi_handle, curl_handle)
    ccall((:curl_multi_remove_handle, libcurl), CURLMcode, (Ptr{CURLM}, Ptr{CURL}), multi_handle, curl_handle)
end

function curl_multi_fdset(multi_handle, read_fd_set, write_fd_set, exc_fd_set, max_fd)
    ccall((:curl_multi_fdset, libcurl), CURLMcode, (Ptr{CURLM}, Ptr{fd_set}, Ptr{fd_set}, Ptr{fd_set}, Ptr{Cint}), multi_handle, read_fd_set, write_fd_set, exc_fd_set, max_fd)
end

function curl_multi_wait(multi_handle, extra_fds, extra_nfds, timeout_ms, ret)
    ccall((:curl_multi_wait, libcurl), CURLMcode, (Ptr{CURLM}, Ptr{curl_waitfd}, Cuint, Cint, Ptr{Cint}), multi_handle, extra_fds, extra_nfds, timeout_ms, ret)
end

function curl_multi_poll(multi_handle, extra_fds, extra_nfds, timeout_ms, ret)
    ccall((:curl_multi_poll, libcurl), CURLMcode, (Ptr{CURLM}, Ptr{curl_waitfd}, Cuint, Cint, Ptr{Cint}), multi_handle, extra_fds, extra_nfds, timeout_ms, ret)
end

function curl_multi_wakeup(multi_handle)
    ccall((:curl_multi_wakeup, libcurl), CURLMcode, (Ptr{CURLM},), multi_handle)
end

function curl_multi_perform(multi_handle, running_handles)
    ccall((:curl_multi_perform, libcurl), CURLMcode, (Ptr{CURLM}, Ptr{Cint}), multi_handle, running_handles)
end

function curl_multi_cleanup(multi_handle)
    ccall((:curl_multi_cleanup, libcurl), CURLMcode, (Ptr{CURLM},), multi_handle)
end

function curl_multi_info_read(multi_handle, msgs_in_queue)
    ccall((:curl_multi_info_read, libcurl), Ptr{CURLMsg}, (Ptr{CURLM}, Ptr{Cint}), multi_handle, msgs_in_queue)
end

function curl_multi_strerror(arg1)
    ccall((:curl_multi_strerror, libcurl), Ptr{Cchar}, (CURLMcode,), arg1)
end

# typedef int ( * curl_socket_callback ) ( CURL * easy , /* easy handle */ curl_socket_t s , /* socket */ int what , /* see above */ void * userp , /* private callback
#                                                        pointer */ void * socketp )
const curl_socket_callback = Ptr{Cvoid}

# typedef int ( * curl_multi_timer_callback ) ( CURLM * multi , /* multi handle */ long timeout_ms , /* see above */ void * userp )
const curl_multi_timer_callback = Ptr{Cvoid}

function curl_multi_socket_action(multi_handle, s, ev_bitmask, running_handles)
    ccall((:curl_multi_socket_action, libcurl), CURLMcode, (Ptr{CURLM}, curl_socket_t, Cint, Ptr{Cint}), multi_handle, s, ev_bitmask, running_handles)
end

function curl_multi_socket_all(multi_handle, running_handles)
    ccall((:curl_multi_socket_all, libcurl), CURLMcode, (Ptr{CURLM}, Ptr{Cint}), multi_handle, running_handles)
end

function curl_multi_timeout(multi_handle, milliseconds)
    ccall((:curl_multi_timeout, libcurl), CURLMcode, (Ptr{CURLM}, Ptr{Clong}), multi_handle, milliseconds)
end

@enum CURLMoption::UInt32 begin
    CURLMOPT_SOCKETFUNCTION = 20001
    CURLMOPT_SOCKETDATA = 10002
    CURLMOPT_PIPELINING = 3
    CURLMOPT_TIMERFUNCTION = 20004
    CURLMOPT_TIMERDATA = 10005
    CURLMOPT_MAXCONNECTS = 6
    CURLMOPT_MAX_HOST_CONNECTIONS = 7
    CURLMOPT_MAX_PIPELINE_LENGTH = 8
    CURLMOPT_CONTENT_LENGTH_PENALTY_SIZE = 30009
    CURLMOPT_CHUNK_LENGTH_PENALTY_SIZE = 30010
    CURLMOPT_PIPELINING_SITE_BL = 10011
    CURLMOPT_PIPELINING_SERVER_BL = 10012
    CURLMOPT_MAX_TOTAL_CONNECTIONS = 13
    CURLMOPT_PUSHFUNCTION = 20014
    CURLMOPT_PUSHDATA = 10015
    CURLMOPT_MAX_CONCURRENT_STREAMS = 16
    CURLMOPT_LASTENTRY = 17
end

# automatic type deduction for variadic arguments may not be what you want, please use with caution
@generated function curl_multi_setopt(multi_handle, option, va_list...)
        :(@ccall(libcurl.curl_multi_setopt(multi_handle::Ptr{CURLM}, option::CURLMoption; $(to_c_type_pairs(va_list)...))::CURLMcode))
    end

function curl_multi_assign(multi_handle, sockfd, sockp)
    ccall((:curl_multi_assign, libcurl), CURLMcode, (Ptr{CURLM}, curl_socket_t, Ptr{Cvoid}), multi_handle, sockfd, sockp)
end

mutable struct curl_pushheaders end

function curl_pushheader_bynum(h, num)
    ccall((:curl_pushheader_bynum, libcurl), Ptr{Cchar}, (Ptr{curl_pushheaders}, Csize_t), h, num)
end

function curl_pushheader_byname(h, name)
    ccall((:curl_pushheader_byname, libcurl), Ptr{Cchar}, (Ptr{curl_pushheaders}, Ptr{Cchar}), h, name)
end

# typedef int ( * curl_push_callback ) ( CURL * parent , CURL * easy , size_t num_headers , struct curl_pushheaders * headers , void * userp )
const curl_push_callback = Ptr{Cvoid}

@enum CURLUcode::UInt32 begin
    CURLUE_OK = 0
    CURLUE_BAD_HANDLE = 1
    CURLUE_BAD_PARTPOINTER = 2
    CURLUE_MALFORMED_INPUT = 3
    CURLUE_BAD_PORT_NUMBER = 4
    CURLUE_UNSUPPORTED_SCHEME = 5
    CURLUE_URLDECODE = 6
    CURLUE_OUT_OF_MEMORY = 7
    CURLUE_USER_NOT_ALLOWED = 8
    CURLUE_UNKNOWN_PART = 9
    CURLUE_NO_SCHEME = 10
    CURLUE_NO_USER = 11
    CURLUE_NO_PASSWORD = 12
    CURLUE_NO_OPTIONS = 13
    CURLUE_NO_HOST = 14
    CURLUE_NO_PORT = 15
    CURLUE_NO_QUERY = 16
    CURLUE_NO_FRAGMENT = 17
end

@enum CURLUPart::UInt32 begin
    CURLUPART_URL = 0
    CURLUPART_SCHEME = 1
    CURLUPART_USER = 2
    CURLUPART_PASSWORD = 3
    CURLUPART_OPTIONS = 4
    CURLUPART_HOST = 5
    CURLUPART_PORT = 6
    CURLUPART_PATH = 7
    CURLUPART_QUERY = 8
    CURLUPART_FRAGMENT = 9
    CURLUPART_ZONEID = 10
end

mutable struct Curl_URL end

const CURLU = Curl_URL

function curl_url()
    ccall((:curl_url, libcurl), Ptr{CURLU}, ())
end

function curl_url_cleanup(handle)
    ccall((:curl_url_cleanup, libcurl), Cvoid, (Ptr{CURLU},), handle)
end

function curl_url_dup(in)
    ccall((:curl_url_dup, libcurl), Ptr{CURLU}, (Ptr{CURLU},), in)
end

function curl_url_get(handle, what, part, flags)
    ccall((:curl_url_get, libcurl), CURLUcode, (Ptr{CURLU}, CURLUPart, Ptr{Ptr{Cchar}}, Cuint), handle, what, part, flags)
end

function curl_url_set(handle, what, part, flags)
    ccall((:curl_url_set, libcurl), CURLUcode, (Ptr{CURLU}, CURLUPart, Ptr{Cchar}, Cuint), handle, what, part, flags)
end

@enum curl_easytype::UInt32 begin
    CURLOT_LONG = 0
    CURLOT_VALUES = 1
    CURLOT_OFF_T = 2
    CURLOT_OBJECT = 3
    CURLOT_STRING = 4
    CURLOT_SLIST = 5
    CURLOT_CBPTR = 6
    CURLOT_BLOB = 7
    CURLOT_FUNCTION = 8
end

mutable struct curl_easyoption
    name::Ptr{Cchar}
    id::CURLoption
    type::curl_easytype
    flags::Cuint
    curl_easyoption() = new()
end

function curl_easy_option_by_name(name)
    ccall((:curl_easy_option_by_name, libcurl), Ptr{curl_easyoption}, (Ptr{Cchar},), name)
end

function curl_easy_option_by_id(id)
    ccall((:curl_easy_option_by_id, libcurl), Ptr{curl_easyoption}, (CURLoption,), id)
end

function curl_easy_option_next(prev)
    ccall((:curl_easy_option_next, libcurl), Ptr{curl_easyoption}, (Ptr{curl_easyoption},), prev)
end

struct __JL_Ctag_144
    data::NTuple{4, UInt8}
end

function Base.getproperty(x::Ptr{__JL_Ctag_144}, f::Symbol)
    f === :whatever && return Ptr{Ptr{Cvoid}}(x + 0)
    f === :result && return Ptr{CURLcode}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::__JL_Ctag_144, f::Symbol)
    r = Ref{__JL_Ctag_144}(x)
    ptr = Base.unsafe_convert(Ptr{__JL_Ctag_144}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{__JL_Ctag_144}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

mutable struct __JL_Ctag_145
    time::Ptr{Cchar}
    perm::Ptr{Cchar}
    user::Ptr{Cchar}
    group::Ptr{Cchar}
    target::Ptr{Cchar}
    __JL_Ctag_145() = new()
end

function Base.getproperty(x::Ptr{__JL_Ctag_145}, f::Symbol)
    f === :time && return Ptr{Ptr{Cchar}}(x + 0)
    f === :perm && return Ptr{Ptr{Cchar}}(x + 4)
    f === :user && return Ptr{Ptr{Cchar}}(x + 8)
    f === :group && return Ptr{Ptr{Cchar}}(x + 12)
    f === :target && return Ptr{Ptr{Cchar}}(x + 16)
    return getfield(x, f)
end

function Base.getproperty(x::__JL_Ctag_145, f::Symbol)
    r = Ref{__JL_Ctag_145}(x)
    ptr = Base.unsafe_convert(Ptr{__JL_Ctag_145}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{__JL_Ctag_145}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

const LIBCURL_COPYRIGHT = "1996 - 2020 Daniel Stenberg, <daniel@haxx.se>."

const LIBCURL_VERSION = "7.73.0"

const LIBCURL_VERSION_MAJOR = 7

const LIBCURL_VERSION_MINOR = 73

const LIBCURL_VERSION_PATCH = 0

const LIBCURL_VERSION_NUM = 0x00074900

const LIBCURL_TIMESTAMP = "2020-10-14"

const CURL_TYPEOF_CURL_OFF_T = Clonglong

const CURL_FORMAT_CURL_OFF_T = "I64d"

const CURL_FORMAT_CURL_OFF_TU = "I64u"

const CURL_TYPEOF_CURL_SOCKLEN_T = socklen_t

const CURL_EXTERN = __declspec(dllimport)

const CURL_SOCKET_BAD = INVALID_SOCKET

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

