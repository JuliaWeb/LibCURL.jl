macro c(ret_type, func, arg_types, lib)
  local args_in = [Symbol('a', i) for i in eachindex(arg_types.args)]
  quote
    $(esc(func))($(args_in...)) = ccall( ($(string(func)), $lib ), $ret_type, $arg_types, $(args_in...) )
  end
end

macro ctypedef(fake_t,real_t)
  quote
    const $(esc(fake_t)) = $(esc(real_t))
  end
end

@ctypedef CURL Union{}
@ctypedef curl_socket_t Int32
mutable struct curl_httppost
  next::Ptr{Nothing}
  name::Ptr{UInt8}
  namelength::Int32
  contents::Ptr{UInt8}
  contentslength::Int32
  buffer::Ptr{UInt8}
  bufferlength::Int32
  contenttype::Ptr{UInt8}
  contentheader::Ptr{Nothing}
  more::Ptr{Nothing}
  flags::Int32
  showfilename::Ptr{UInt8}
  userp::Ptr{Nothing}
end
@ctypedef curl_progress_callback Ptr{Nothing}
@ctypedef curl_write_callback Ptr{Nothing}
# enum curlfiletype
const CURLFILETYPE_FILE = 0
const CURLFILETYPE_DIRECTORY = 1
const CURLFILETYPE_SYMLINK = 2
const CURLFILETYPE_DEVICE_BLOCK = 3
const CURLFILETYPE_DEVICE_CHAR = 4
const CURLFILETYPE_NAMEDPIPE = 5
const CURLFILETYPE_SOCKET = 6
const CURLFILETYPE_DOOR = 7
const CURLFILETYPE_UNKNOWN = 8
# end
@ctypedef curlfiletype Int32
mutable struct curl_fileinfo
  filename::Ptr{UInt8}
  filetype::curlfiletype
  time::time_t
  perm::UInt32
  uid::Int32
  gid::Int32
  size::curl_off_t
  hardlinks::Int32
  strings::Nothing
  flags::UInt32
  b_data::Ptr{UInt8}
  b_size::size_t
  b_used::size_t
end
@ctypedef curl_chunk_bgn_callback Ptr{Nothing}
@ctypedef curl_chunk_end_callback Ptr{Nothing}
@ctypedef curl_fnmatch_callback Ptr{Nothing}
@ctypedef curl_seek_callback Ptr{Nothing}
@ctypedef curl_read_callback Ptr{Nothing}
# enum curlsocktype
const CURLSOCKTYPE_IPCXN = 0
const CURLSOCKTYPE_LAST = 1
# end
@ctypedef curlsocktype Int32
@ctypedef curl_sockopt_callback Ptr{Nothing}
mutable struct curl_sockaddr
  family::Int32
  socktype::Int32
  protocol::Int32
  addrlen::UInt32
  addr::Nothing
end
@ctypedef curl_opensocket_callback Ptr{Nothing}
@ctypedef curl_closesocket_callback Ptr{Nothing}
# enum curlioerr
const CURLIOE_OK = 0
const CURLIOE_UNKNOWNCMD = 1
const CURLIOE_FAILRESTART = 2
const CURLIOE_LAST = 3
# end
@ctypedef curlioerr Int32
# enum curliocmd
const CURLIOCMD_NOP = 0
const CURLIOCMD_RESTARTREAD = 1
const CURLIOCMD_LAST = 2
# end
@ctypedef curliocmd Int32
@ctypedef curl_ioctl_callback Ptr{Nothing}
@ctypedef curl_malloc_callback Ptr{Nothing}
@ctypedef curl_free_callback Ptr{Nothing}
@ctypedef curl_realloc_callback Ptr{Nothing}
@ctypedef curl_strdup_callback Ptr{Nothing}
@ctypedef curl_calloc_callback Ptr{Nothing}
# enum curl_infotype
const CURLINFO_TEXT = 0
const CURLINFO_HEADER_IN = 1
const CURLINFO_HEADER_OUT = 2
const CURLINFO_DATA_IN = 3
const CURLINFO_DATA_OUT = 4
const CURLINFO_SSL_DATA_IN = 5
const CURLINFO_SSL_DATA_OUT = 6
const CURLINFO_END = 7
# end
@ctypedef curl_infotype Int32
@ctypedef curl_debug_callback Ptr{Nothing}
# enum CURLcode
const CURLE_OK = 0
const CURLE_UNSUPPORTED_PROTOCOL = 1
const CURLE_FAILED_INIT = 2
const CURLE_URL_MALFORMAT = 3
const CURLE_NOT_BUILT_IN = 4
const CURLE_COULDNT_RESOLVE_PROXY = 5
const CURLE_COULDNT_RESOLVE_HOST = 6
const CURLE_COULDNT_CONNECT = 7
const CURLE_FTP_WEIRD_SERVER_REPLY = 8
const CURLE_REMOTE_ACCESS_DENIED = 9
const CURLE_FTP_ACCEPT_FAILED = 10
const CURLE_FTP_WEIRD_PASS_REPLY = 11
const CURLE_FTP_ACCEPT_TIMEOUT = 12
const CURLE_FTP_WEIRD_PASV_REPLY = 13
const CURLE_FTP_WEIRD_227_FORMAT = 14
const CURLE_FTP_CANT_GET_HOST = 15
const CURLE_OBSOLETE16 = 16
const CURLE_FTP_COULDNT_SET_TYPE = 17
const CURLE_PARTIAL_FILE = 18
const CURLE_FTP_COULDNT_RETR_FILE = 19
const CURLE_OBSOLETE20 = 20
const CURLE_QUOTE_ERROR = 21
const CURLE_HTTP_RETURNED_ERROR = 22
const CURLE_WRITE_ERROR = 23
const CURLE_OBSOLETE24 = 24
const CURLE_UPLOAD_FAILED = 25
const CURLE_READ_ERROR = 26
const CURLE_OUT_OF_MEMORY = 27
const CURLE_OPERATION_TIMEDOUT = 28
const CURLE_OBSOLETE29 = 29
const CURLE_FTP_PORT_FAILED = 30
const CURLE_FTP_COULDNT_USE_REST = 31
const CURLE_OBSOLETE32 = 32
const CURLE_RANGE_ERROR = 33
const CURLE_HTTP_POST_ERROR = 34
const CURLE_SSL_CONNECT_ERROR = 35
const CURLE_BAD_DOWNLOAD_RESUME = 36
const CURLE_FILE_COULDNT_READ_FILE = 37
const CURLE_LDAP_CANNOT_BIND = 38
const CURLE_LDAP_SEARCH_FAILED = 39
const CURLE_OBSOLETE40 = 40
const CURLE_FUNCTION_NOT_FOUND = 41
const CURLE_ABORTED_BY_CALLBACK = 42
const CURLE_BAD_FUNCTION_ARGUMENT = 43
const CURLE_OBSOLETE44 = 44
const CURLE_INTERFACE_FAILED = 45
const CURLE_OBSOLETE46 = 46
const CURLE_TOO_MANY_REDIRECTS = 47
const CURLE_UNKNOWN_OPTION = 48
const CURLE_TELNET_OPTION_SYNTAX = 49
const CURLE_OBSOLETE50 = 50
const CURLE_PEER_FAILED_VERIFICATION = 51
const CURLE_GOT_NOTHING = 52
const CURLE_SSL_ENGINE_NOTFOUND = 53
const CURLE_SSL_ENGINE_SETFAILED = 54
const CURLE_SEND_ERROR = 55
const CURLE_RECV_ERROR = 56
const CURLE_OBSOLETE57 = 57
const CURLE_SSL_CERTPROBLEM = 58
const CURLE_SSL_CIPHER = 59
const CURLE_SSL_CACERT = 60
const CURLE_BAD_CONTENT_ENCODING = 61
const CURLE_LDAP_INVALID_URL = 62
const CURLE_FILESIZE_EXCEEDED = 63
const CURLE_USE_SSL_FAILED = 64
const CURLE_SEND_FAIL_REWIND = 65
const CURLE_SSL_ENGINE_INITFAILED = 66
const CURLE_LOGIN_DENIED = 67
const CURLE_TFTP_NOTFOUND = 68
const CURLE_TFTP_PERM = 69
const CURLE_REMOTE_DISK_FULL = 70
const CURLE_TFTP_ILLEGAL = 71
const CURLE_TFTP_UNKNOWNID = 72
const CURLE_REMOTE_FILE_EXISTS = 73
const CURLE_TFTP_NOSUCHUSER = 74
const CURLE_CONV_FAILED = 75
const CURLE_CONV_REQD = 76
const CURLE_SSL_CACERT_BADFILE = 77
const CURLE_REMOTE_FILE_NOT_FOUND = 78
const CURLE_SSH = 79
const CURLE_SSL_SHUTDOWN_FAILED = 80
const CURLE_AGAIN = 81
const CURLE_SSL_CRL_BADFILE = 82
const CURLE_SSL_ISSUER_ERROR = 83
const CURLE_FTP_PRET_FAILED = 84
const CURLE_RTSP_CSEQ_ERROR = 85
const CURLE_RTSP_SESSION_ERROR = 86
const CURLE_FTP_BAD_FILE_LIST = 87
const CURLE_CHUNK_FAILED = 88
const CURL_LAST = 89
# end
@ctypedef CURLcode Int32
@ctypedef curl_conv_callback Ptr{Nothing}
@ctypedef curl_ssl_ctx_callback Ptr{Nothing}
# enum curl_proxytype
const CURLPROXY_HTTP = 0
const CURLPROXY_HTTP_1_0 = 1
const CURLPROXY_SOCKS4 = 4
const CURLPROXY_SOCKS5 = 5
const CURLPROXY_SOCKS4A = 6
const CURLPROXY_SOCKS5_HOSTNAME = 7
# end
@ctypedef curl_proxytype Int32
mutable struct curl_khkey
  key::Ptr{UInt8}
  len::size_t
  keytype::Int32
end
# enum curl_khstat
const CURLKHSTAT_FINE_ADD_TO_FILE = 0
const CURLKHSTAT_FINE = 1
const CURLKHSTAT_REJECT = 2
const CURLKHSTAT_DEFER = 3
const CURLKHSTAT_LAST = 4
# end
# enum curl_khmatch
const CURLKHMATCH_OK = 0
const CURLKHMATCH_MISMATCH = 1
const CURLKHMATCH_MISSING = 2
const CURLKHMATCH_LAST = 3
# end
@ctypedef curl_sshkeycallback Ptr{Nothing}
# enum curl_usessl
const CURLUSESSL_NONE = 0
const CURLUSESSL_TRY = 1
const CURLUSESSL_CONTROL = 2
const CURLUSESSL_ALL = 3
const CURLUSESSL_LAST = 4
# end
@ctypedef curl_usessl Int32
# enum curl_ftpccc
const CURLFTPSSL_CCC_NONE = 0
const CURLFTPSSL_CCC_PASSIVE = 1
const CURLFTPSSL_CCC_ACTIVE = 2
const CURLFTPSSL_CCC_LAST = 3
# end
@ctypedef curl_ftpccc Int32
# enum curl_ftpauth
const CURLFTPAUTH_DEFAULT = 0
const CURLFTPAUTH_SSL = 1
const CURLFTPAUTH_TLS = 2
const CURLFTPAUTH_LAST = 3
# end
@ctypedef curl_ftpauth Int32
# enum curl_ftpcreatedir
const CURLFTP_CREATE_DIR_NONE = 0
const CURLFTP_CREATE_DIR = 1
const CURLFTP_CREATE_DIR_RETRY = 2
const CURLFTP_CREATE_DIR_LAST = 3
# end
@ctypedef curl_ftpcreatedir Int32
# enum curl_ftpmethod
const CURLFTPMETHOD_DEFAULT = 0
const CURLFTPMETHOD_MULTICWD = 1
const CURLFTPMETHOD_NOCWD = 2
const CURLFTPMETHOD_SINGLECWD = 3
const CURLFTPMETHOD_LAST = 4
# end
@ctypedef curl_ftpmethod Int32
# enum CURLoption
const CURLOPT_FILE = 10001
const CURLOPT_URL = 10002
const CURLOPT_PORT = 3
const CURLOPT_PROXY = 10004
const CURLOPT_USERPWD = 10005
const CURLOPT_PROXYUSERPWD = 10006
const CURLOPT_RANGE = 10007
const CURLOPT_INFILE = 10009
const CURLOPT_ERRORBUFFER = 10010
const CURLOPT_WRITEFUNCTION = 20011
const CURLOPT_READFUNCTION = 20012
const CURLOPT_TIMEOUT = 13
const CURLOPT_INFILESIZE = 14
const CURLOPT_POSTFIELDS = 10015
const CURLOPT_REFERER = 10016
const CURLOPT_FTPPORT = 10017
const CURLOPT_USERAGENT = 10018
const CURLOPT_LOW_SPEED_LIMIT = 19
const CURLOPT_LOW_SPEED_TIME = 20
const CURLOPT_RESUME_FROM = 21
const CURLOPT_COOKIE = 10022
const CURLOPT_HTTPHEADER = 10023
const CURLOPT_HTTPPOST = 10024
const CURLOPT_SSLCERT = 10025
const CURLOPT_KEYPASSWD = 10026
const CURLOPT_CRLF = 27
const CURLOPT_QUOTE = 10028
const CURLOPT_WRITEHEADER = 10029
const CURLOPT_COOKIEFILE = 10031
const CURLOPT_SSLVERSION = 32
const CURLOPT_TIMECONDITION = 33
const CURLOPT_TIMEVALUE = 34
const CURLOPT_CUSTOMREQUEST = 10036
const CURLOPT_STDERR = 10037
const CURLOPT_POSTQUOTE = 10039
const CURLOPT_WRITEINFO = 10040
const CURLOPT_VERBOSE = 41
const CURLOPT_HEADER = 42
const CURLOPT_NOPROGRESS = 43
const CURLOPT_NOBODY = 44
const CURLOPT_FAILONERROR = 45
const CURLOPT_UPLOAD = 46
const CURLOPT_POST = 47
const CURLOPT_DIRLISTONLY = 48
const CURLOPT_APPEND = 50
const CURLOPT_NETRC = 51
const CURLOPT_FOLLOWLOCATION = 52
const CURLOPT_TRANSFERTEXT = 53
const CURLOPT_PUT = 54
const CURLOPT_PROGRESSFUNCTION = 20056
const CURLOPT_PROGRESSDATA = 10057
const CURLOPT_AUTOREFERER = 58
const CURLOPT_PROXYPORT = 59
const CURLOPT_POSTFIELDSIZE = 60
const CURLOPT_HTTPPROXYTUNNEL = 61
const CURLOPT_INTERFACE = 10062
const CURLOPT_KRBLEVEL = 10063
const CURLOPT_SSL_VERIFYPEER = 64
const CURLOPT_CAINFO = 10065
const CURLOPT_MAXREDIRS = 68
const CURLOPT_FILETIME = 69
const CURLOPT_TELNETOPTIONS = 10070
const CURLOPT_MAXCONNECTS = 71
const CURLOPT_CLOSEPOLICY = 72
const CURLOPT_FRESH_CONNECT = 74
const CURLOPT_FORBID_REUSE = 75
const CURLOPT_RANDOM_FILE = 10076
const CURLOPT_EGDSOCKET = 10077
const CURLOPT_CONNECTTIMEOUT = 78
const CURLOPT_HEADERFUNCTION = 20079
const CURLOPT_HTTPGET = 80
const CURLOPT_SSL_VERIFYHOST = 81
const CURLOPT_COOKIEJAR = 10082
const CURLOPT_SSL_CIPHER_LIST = 10083
const CURLOPT_HTTP_VERSION = 84
const CURLOPT_FTP_USE_EPSV = 85
const CURLOPT_SSLCERTTYPE = 10086
const CURLOPT_SSLKEY = 10087
const CURLOPT_SSLKEYTYPE = 10088
const CURLOPT_SSLENGINE = 10089
const CURLOPT_SSLENGINE_DEFAULT = 90
const CURLOPT_DNS_USE_GLOBAL_CACHE = 91
const CURLOPT_DNS_CACHE_TIMEOUT = 92
const CURLOPT_PREQUOTE = 10093
const CURLOPT_DEBUGFUNCTION = 20094
const CURLOPT_DEBUGDATA = 10095
const CURLOPT_COOKIESESSION = 96
const CURLOPT_CAPATH = 10097
const CURLOPT_BUFFERSIZE = 98
const CURLOPT_NOSIGNAL = 99
const CURLOPT_SHARE = 10100
const CURLOPT_PROXYTYPE = 101
const CURLOPT_ACCEPT_ENCODING = 10102
const CURLOPT_PRIVATE = 10103
const CURLOPT_HTTP200ALIASES = 10104
const CURLOPT_UNRESTRICTED_AUTH = 105
const CURLOPT_FTP_USE_EPRT = 106
const CURLOPT_HTTPAUTH = 107
const CURLOPT_SSL_CTX_FUNCTION = 20108
const CURLOPT_SSL_CTX_DATA = 10109
const CURLOPT_FTP_CREATE_MISSING_DIRS = 110
const CURLOPT_PROXYAUTH = 111
const CURLOPT_FTP_RESPONSE_TIMEOUT = 112
const CURLOPT_IPRESOLVE = 113
const CURLOPT_MAXFILESIZE = 114
const CURLOPT_INFILESIZE_LARGE = 30115
const CURLOPT_RESUME_FROM_LARGE = 30116
const CURLOPT_MAXFILESIZE_LARGE = 30117
const CURLOPT_NETRC_FILE = 10118
const CURLOPT_USE_SSL = 119
const CURLOPT_POSTFIELDSIZE_LARGE = 30120
const CURLOPT_TCP_NODELAY = 121
const CURLOPT_FTPSSLAUTH = 129
const CURLOPT_IOCTLFUNCTION = 20130
const CURLOPT_IOCTLDATA = 10131
const CURLOPT_FTP_ACCOUNT = 10134
const CURLOPT_COOKIELIST = 10135
const CURLOPT_IGNORE_CONTENT_LENGTH = 136
const CURLOPT_FTP_SKIP_PASV_IP = 137
const CURLOPT_FTP_FILEMETHOD = 138
const CURLOPT_LOCALPORT = 139
const CURLOPT_LOCALPORTRANGE = 140
const CURLOPT_CONNECT_ONLY = 141
const CURLOPT_CONV_FROM_NETWORK_FUNCTION = 20142
const CURLOPT_CONV_TO_NETWORK_FUNCTION = 20143
const CURLOPT_CONV_FROM_UTF8_FUNCTION = 20144
const CURLOPT_MAX_SEND_SPEED_LARGE = 30145
const CURLOPT_MAX_RECV_SPEED_LARGE = 30146
const CURLOPT_FTP_ALTERNATIVE_TO_USER = 10147
const CURLOPT_SOCKOPTFUNCTION = 20148
const CURLOPT_SOCKOPTDATA = 10149
const CURLOPT_SSL_SESSIONID_CACHE = 150
const CURLOPT_SSH_AUTH_TYPES = 151
const CURLOPT_SSH_PUBLIC_KEYFILE = 10152
const CURLOPT_SSH_PRIVATE_KEYFILE = 10153
const CURLOPT_FTP_SSL_CCC = 154
const CURLOPT_TIMEOUT_MS = 155
const CURLOPT_CONNECTTIMEOUT_MS = 156
const CURLOPT_HTTP_TRANSFER_DECODING = 157
const CURLOPT_HTTP_CONTENT_DECODING = 158
const CURLOPT_NEW_FILE_PERMS = 159
const CURLOPT_NEW_DIRECTORY_PERMS = 160
const CURLOPT_POSTREDIR = 161
const CURLOPT_SSH_HOST_PUBLIC_KEY_MD5 = 10162
const CURLOPT_OPENSOCKETFUNCTION = 20163
const CURLOPT_OPENSOCKETDATA = 10164
const CURLOPT_COPYPOSTFIELDS = 10165
const CURLOPT_PROXY_TRANSFER_MODE = 166
const CURLOPT_SEEKFUNCTION = 20167
const CURLOPT_SEEKDATA = 10168
const CURLOPT_CRLFILE = 10169
const CURLOPT_ISSUERCERT = 10170
const CURLOPT_ADDRESS_SCOPE = 171
const CURLOPT_CERTINFO = 172
const CURLOPT_USERNAME = 10173
const CURLOPT_PASSWORD = 10174
const CURLOPT_PROXYUSERNAME = 10175
const CURLOPT_PROXYPASSWORD = 10176
const CURLOPT_NOPROXY = 10177
const CURLOPT_TFTP_BLKSIZE = 178
const CURLOPT_SOCKS5_GSSAPI_SERVICE = 10179
const CURLOPT_SOCKS5_GSSAPI_NEC = 180
const CURLOPT_PROTOCOLS = 181
const CURLOPT_REDIR_PROTOCOLS = 182
const CURLOPT_SSH_KNOWNHOSTS = 10183
const CURLOPT_SSH_KEYFUNCTION = 20184
const CURLOPT_SSH_KEYDATA = 10185
const CURLOPT_MAIL_FROM = 10186
const CURLOPT_MAIL_RCPT = 10187
const CURLOPT_FTP_USE_PRET = 188
const CURLOPT_RTSP_REQUEST = 189
const CURLOPT_RTSP_SESSION_ID = 10190
const CURLOPT_RTSP_STREAM_URI = 10191
const CURLOPT_RTSP_TRANSPORT = 10192
const CURLOPT_RTSP_CLIENT_CSEQ = 193
const CURLOPT_RTSP_SERVER_CSEQ = 194
const CURLOPT_INTERLEAVEDATA = 10195
const CURLOPT_INTERLEAVEFUNCTION = 20196
const CURLOPT_WILDCARDMATCH = 197
const CURLOPT_CHUNK_BGN_FUNCTION = 20198
const CURLOPT_CHUNK_END_FUNCTION = 20199
const CURLOPT_FNMATCH_FUNCTION = 20200
const CURLOPT_CHUNK_DATA = 10201
const CURLOPT_FNMATCH_DATA = 10202
const CURLOPT_RESOLVE = 10203
const CURLOPT_TLSAUTH_USERNAME = 10204
const CURLOPT_TLSAUTH_PASSWORD = 10205
const CURLOPT_TLSAUTH_TYPE = 10206
const CURLOPT_TRANSFER_ENCODING = 207
const CURLOPT_CLOSESOCKETFUNCTION = 20208
const CURLOPT_CLOSESOCKETDATA = 10209
const CURLOPT_GSSAPI_DELEGATION = 210
const CURLOPT_DNS_SERVERS = 10211
const CURLOPT_ACCEPTTIMEOUT_MS = 212
const CURLOPT_TCP_KEEPALIVE = 213
const CURLOPT_TCP_KEEPIDLE = 214
const CURLOPT_TCP_KEEPINTVL = 215
const CURLOPT_SSL_OPTIONS = 216
const CURLOPT_MAIL_AUTH = 10217
const CURLOPT_LASTENTRY = 10218
# end
@ctypedef CURLoption Int32
# enum ANONYMOUS
const CURL_HTTP_VERSION_NONE = 0
const CURL_HTTP_VERSION_1_0 = 1
const CURL_HTTP_VERSION_1_1 = 2
const CURL_HTTP_VERSION_LAST = 3
# end
# enum CURL_NETRC_OPTION
const CURL_NETRC_IGNORED = 0
const CURL_NETRC_OPTIONAL = 1
const CURL_NETRC_REQUIRED = 2
const CURL_NETRC_LAST = 3
# end
# enum CURL_TLSAUTH
const CURL_TLSAUTH_NONE = 0
const CURL_TLSAUTH_SRP = 1
const CURL_TLSAUTH_LAST = 2
# end
# enum curl_TimeCond
const CURL_TIMECOND_NONE = 0
const CURL_TIMECOND_IFMODSINCE = 1
const CURL_TIMECOND_IFUNMODSINCE = 2
const CURL_TIMECOND_LASTMOD = 3
const CURL_TIMECOND_LAST = 4
# end
@ctypedef curl_TimeCond Int32
# enum CURLformoption
const CURLFORM_NOTHING = 0
const CURLFORM_COPYNAME = 1
const CURLFORM_PTRNAME = 2
const CURLFORM_NAMELENGTH = 3
const CURLFORM_COPYCONTENTS = 4
const CURLFORM_PTRCONTENTS = 5
const CURLFORM_CONTENTSLENGTH = 6
const CURLFORM_FILECONTENT = 7
const CURLFORM_ARRAY = 8
const CURLFORM_OBSOLETE = 9
const CURLFORM_FILE = 10
const CURLFORM_BUFFER = 11
const CURLFORM_BUFFERPTR = 12
const CURLFORM_BUFFERLENGTH = 13
const CURLFORM_CONTENTTYPE = 14
const CURLFORM_CONTENTHEADER = 15
const CURLFORM_FILENAME = 16
const CURLFORM_END = 17
const CURLFORM_OBSOLETE2 = 18
const CURLFORM_STREAM = 19
const CURLFORM_LASTENTRY = 20
# end
@ctypedef CURLformoption Int32
mutable struct curl_forms
  option::CURLformoption
  value::Ptr{UInt8}
end
# enum CURLFORMcode
const CURL_FORMADD_OK = 0
const CURL_FORMADD_MEMORY = 1
const CURL_FORMADD_OPTION_TWICE = 2
const CURL_FORMADD_NULL = 3
const CURL_FORMADD_UNKNOWN_OPTION = 4
const CURL_FORMADD_INCOMPLETE = 5
const CURL_FORMADD_ILLEGAL_ARRAY = 6
const CURL_FORMADD_DISABLED = 7
const CURL_FORMADD_LAST = 8
# end
@ctypedef CURLFORMcode Int32
@ctypedef curl_formget_callback Ptr{Nothing}
mutable struct curl_slist
  data::Ptr{UInt8}
  next::Ptr{Nothing}
end
mutable struct curl_certinfo
  num_of_certs::Int32
  certinfo::Ptr{Ptr{Nothing}}
end
# enum CURLINFO
const CURLINFO_NONE = 0
const CURLINFO_EFFECTIVE_URL = 1048577
const CURLINFO_RESPONSE_CODE = 2097154
const CURLINFO_TOTAL_TIME = 3145731
const CURLINFO_NAMELOOKUP_TIME = 3145732
const CURLINFO_CONNECT_TIME = 3145733
const CURLINFO_PRETRANSFER_TIME = 3145734
const CURLINFO_SIZE_UPLOAD = 3145735
const CURLINFO_SIZE_DOWNLOAD = 3145736
const CURLINFO_SPEED_DOWNLOAD = 3145737
const CURLINFO_SPEED_UPLOAD = 3145738
const CURLINFO_HEADER_SIZE = 2097163
const CURLINFO_REQUEST_SIZE = 2097164
const CURLINFO_SSL_VERIFYRESULT = 2097165
const CURLINFO_FILETIME = 2097166
const CURLINFO_CONTENT_LENGTH_DOWNLOAD = 3145743
const CURLINFO_CONTENT_LENGTH_UPLOAD = 3145744
const CURLINFO_STARTTRANSFER_TIME = 3145745
const CURLINFO_CONTENT_TYPE = 1048594
const CURLINFO_REDIRECT_TIME = 3145747
const CURLINFO_REDIRECT_COUNT = 2097172
const CURLINFO_PRIVATE = 1048597
const CURLINFO_HTTP_CONNECTCODE = 2097174
const CURLINFO_HTTPAUTH_AVAIL = 2097175
const CURLINFO_PROXYAUTH_AVAIL = 2097176
const CURLINFO_OS_ERRNO = 2097177
const CURLINFO_NUM_CONNECTS = 2097178
const CURLINFO_SSL_ENGINES = 4194331
const CURLINFO_COOKIELIST = 4194332
const CURLINFO_LASTSOCKET = 2097181
const CURLINFO_FTP_ENTRY_PATH = 1048606
const CURLINFO_REDIRECT_URL = 1048607
const CURLINFO_PRIMARY_IP = 1048608
const CURLINFO_APPCONNECT_TIME = 3145761
const CURLINFO_CERTINFO = 4194338
const CURLINFO_CONDITION_UNMET = 2097187
const CURLINFO_RTSP_SESSION_ID = 1048612
const CURLINFO_RTSP_CLIENT_CSEQ = 2097189
const CURLINFO_RTSP_SERVER_CSEQ = 2097190
const CURLINFO_RTSP_CSEQ_RECV = 2097191
const CURLINFO_PRIMARY_PORT = 2097192
const CURLINFO_LOCAL_IP = 1048617
const CURLINFO_LOCAL_PORT = 2097194
const CURLINFO_LASTONE = 42
# end
@ctypedef CURLINFO Int32
# enum curl_closepolicy
const CURLCLOSEPOLICY_NONE = 0
const CURLCLOSEPOLICY_OLDEST = 1
const CURLCLOSEPOLICY_LEAST_RECENTLY_USED = 2
const CURLCLOSEPOLICY_LEAST_TRAFFIC = 3
const CURLCLOSEPOLICY_SLOWEST = 4
const CURLCLOSEPOLICY_CALLBACK = 5
const CURLCLOSEPOLICY_LAST = 6
# end
@ctypedef curl_closepolicy Int32
# enum curl_lock_data
const CURL_LOCK_DATA_NONE = 0
const CURL_LOCK_DATA_SHARE = 1
const CURL_LOCK_DATA_COOKIE = 2
const CURL_LOCK_DATA_DNS = 3
const CURL_LOCK_DATA_SSL_SESSION = 4
const CURL_LOCK_DATA_CONNECT = 5
const CURL_LOCK_DATA_LAST = 6
# end
@ctypedef curl_lock_data Int32
# enum curl_lock_access
const CURL_LOCK_ACCESS_NONE = 0
const CURL_LOCK_ACCESS_SHARED = 1
const CURL_LOCK_ACCESS_SINGLE = 2
const CURL_LOCK_ACCESS_LAST = 3
# end
@ctypedef curl_lock_access Int32
@ctypedef curl_lock_function Ptr{Nothing}
@ctypedef curl_unlock_function Ptr{Nothing}
@ctypedef CURLSH Union{}
# enum CURLSHcode
const CURLSHE_OK = 0
const CURLSHE_BAD_OPTION = 1
const CURLSHE_IN_USE = 2
const CURLSHE_INVALID = 3
const CURLSHE_NOMEM = 4
const CURLSHE_NOT_BUILT_IN = 5
const CURLSHE_LAST = 6
# end
@ctypedef CURLSHcode Int32
# enum CURLSHoption
const CURLSHOPT_NONE = 0
const CURLSHOPT_SHARE = 1
const CURLSHOPT_UNSHARE = 2
const CURLSHOPT_LOCKFUNC = 3
const CURLSHOPT_UNLOCKFUNC = 4
const CURLSHOPT_USERDATA = 5
const CURLSHOPT_LAST = 6
# end
@ctypedef CURLSHoption Int32
# enum CURLversion
const CURLVERSION_FIRST = 0
const CURLVERSION_SECOND = 1
const CURLVERSION_THIRD = 2
const CURLVERSION_FOURTH = 3
const CURLVERSION_LAST = 4
# end
@ctypedef CURLversion Int32
mutable struct curl_version_info_data
  age::CURLversion
  version::Ptr{UInt8}
  version_num::UInt32
  host::Ptr{UInt8}
  features::Int32
  ssl_version::Ptr{UInt8}
  ssl_version_num::Int32
  libz_version::Ptr{UInt8}
  protocols::Ptr{Ptr{UInt8}}
  ares::Ptr{UInt8}
  ares_num::Int32
  libidn::Ptr{UInt8}
  iconv_ver_num::Int32
  libssh_version::Ptr{UInt8}
end
@ctypedef CURLM Union{}
# enum CURLMcode
const CURLM_CALL_MULTI_PERFORM = -1
const CURLM_OK = 0
const CURLM_BAD_HANDLE = 1
const CURLM_BAD_EASY_HANDLE = 2
const CURLM_OUT_OF_MEMORY = 3
const CURLM_INTERNAL_ERROR = 4
const CURLM_BAD_SOCKET = 5
const CURLM_UNKNOWN_OPTION = 6
const CURLM_LAST = 7
# end
@ctypedef CURLMcode Int32
# enum CURLMSG
const CURLMSG_NONE = 0
const CURLMSG_DONE = 1
const CURLMSG_LAST = 2
# end
@ctypedef CURLMSG Int32
mutable struct CURLMsg
  msg::CURLMSG
  easy_handle::Ptr{CURL}
  data::Nothing
end
@ctypedef curl_socket_callback Ptr{Nothing}
@ctypedef curl_multi_timer_callback Ptr{Nothing}
# enum CURLMoption
const CURLMOPT_SOCKETFUNCTION = 20001
const CURLMOPT_SOCKETDATA = 10002
const CURLMOPT_PIPELINING = 3
const CURLMOPT_TIMERFUNCTION = 20004
const CURLMOPT_TIMERDATA = 10005
const CURLMOPT_MAXCONNECTS = 6
const CURLMOPT_LASTENTRY = 7
# end
@ctypedef CURLMoption Int32
@ctypedef fd_set Union{}
