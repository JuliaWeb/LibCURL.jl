#   Generating #define constants
const CURL_TYPEOF_CURL_OFF_T             = Clong
const CURL_FORMAT_CURL_OFF_T             = "ld"
const CURL_FORMAT_CURL_OFF_TU            = "lu"
const CURL_SUFFIX_CURL_OFF_T             = Clong
const CURL_SUFFIX_CURL_OFF_TU            = Culong
const CURL_TYPEOF_CURL_SOCKLEN_T         = Int32
const CURL_PULL_SYS_TYPES_H              = 1
const CURL_PULL_SYS_SOCKET_H             = 1
const CURL_SOCKET_BAD                    = -1
const CURLSSLBACKEND_LIBRESSL            = CURLSSLBACKEND_OPENSSL
const CURLSSLBACKEND_BORINGSSL           = CURLSSLBACKEND_OPENSSL
const CURLSSLBACKEND_CYASSL              = CURLSSLBACKEND_WOLFSSL
const CURL_HTTPPOST_FILENAME             = (1<<0)
const CURL_HTTPPOST_READFILE             = (1<<1)
const CURL_HTTPPOST_PTRNAME              = (1<<2)
const CURL_HTTPPOST_PTRCONTENTS          = (1<<3)
const CURL_HTTPPOST_BUFFER               = (1<<4)
const CURL_HTTPPOST_PTRBUFFER            = (1<<5)
const CURL_HTTPPOST_CALLBACK             = (1<<6)
const CURL_HTTPPOST_LARGE                = (1<<7)
const CURL_MAX_READ_SIZE                 = 524288
const CURL_MAX_WRITE_SIZE                = 16384
const CURL_MAX_HTTP_HEADER               = (100*1024)
const CURL_WRITEFUNC_PAUSE               = 0x10000001
const CURLFINFOFLAG_KNOWN_FILENAME       = (1<<0)
const CURLFINFOFLAG_KNOWN_FILETYPE       = (1<<1)
const CURLFINFOFLAG_KNOWN_TIME           = (1<<2)
const CURLFINFOFLAG_KNOWN_PERM           = (1<<3)
const CURLFINFOFLAG_KNOWN_UID            = (1<<4)
const CURLFINFOFLAG_KNOWN_GID            = (1<<5)
const CURLFINFOFLAG_KNOWN_SIZE           = (1<<6)
const CURLFINFOFLAG_KNOWN_HLINKCOUNT     = (1<<7)
const CURL_CHUNK_BGN_FUNC_OK             = 0
const CURL_CHUNK_BGN_FUNC_FAIL           = 1
const CURL_CHUNK_BGN_FUNC_SKIP           = 2
const CURL_CHUNK_END_FUNC_OK             = 0
const CURL_CHUNK_END_FUNC_FAIL           = 1
const CURL_FNMATCHFUNC_MATCH             = 0
const CURL_FNMATCHFUNC_NOMATCH           = 1
const CURL_FNMATCHFUNC_FAIL              = 2
const CURL_SEEKFUNC_OK                   = 0
const CURL_SEEKFUNC_FAIL                 = 1
const CURL_SEEKFUNC_CANTSEEK             = 2
const CURL_READFUNC_ABORT                = 0x10000000
const CURL_READFUNC_PAUSE                = 0x10000001
const CURL_SOCKOPT_OK                    = 0
const CURL_SOCKOPT_ERROR                 = 1
const CURL_SOCKOPT_ALREADY_CONNECTED     = 2
const CURLE_OBSOLETE16                   = CURLE_HTTP2
const CURLE_OBSOLETE10                   = CURLE_FTP_ACCEPT_FAILED
const CURLE_OBSOLETE12                   = CURLE_FTP_ACCEPT_TIMEOUT
const CURLOPT_ENCODING                   = CURLOPT_ACCEPT_ENCODING
const CURLE_FTP_WEIRD_SERVER_REPLY       = CURLE_WEIRD_SERVER_REPLY
const CURLE_UNKNOWN_TELNET_OPTION        = CURLE_UNKNOWN_OPTION
const CURLE_SSL_PEER_CERTIFICATE         = CURLE_PEER_FAILED_VERIFICATION
const CURLE_OBSOLETE                     = CURLE_OBSOLETE50
const CURLE_BAD_PASSWORD_ENTERED         = CURLE_OBSOLETE46
const CURLE_BAD_CALLING_ORDER            = CURLE_OBSOLETE44
const CURLE_FTP_USER_PASSWORD_INCORRECT  = CURLE_OBSOLETE10
const CURLE_FTP_CANT_RECONNECT           = CURLE_OBSOLETE16
const CURLE_FTP_COULDNT_GET_SIZE         = CURLE_OBSOLETE32
const CURLE_FTP_COULDNT_SET_ASCII        = CURLE_OBSOLETE29
const CURLE_FTP_WEIRD_USER_REPLY         = CURLE_OBSOLETE12
const CURLE_FTP_WRITE_ERROR              = CURLE_OBSOLETE20
const CURLE_LIBRARY_NOT_FOUND            = CURLE_OBSOLETE40
const CURLE_MALFORMAT_USER               = CURLE_OBSOLETE24
const CURLE_SHARE_IN_USE                 = CURLE_OBSOLETE57
const CURLE_URL_MALFORMAT_USER           = CURLE_NOT_BUILT_IN
const CURLE_FTP_ACCESS_DENIED            = CURLE_REMOTE_ACCESS_DENIED
const CURLE_FTP_COULDNT_SET_BINARY       = CURLE_FTP_COULDNT_SET_TYPE
const CURLE_FTP_QUOTE_ERROR              = CURLE_QUOTE_ERROR
const CURLE_TFTP_DISKFULL                = CURLE_REMOTE_DISK_FULL
const CURLE_TFTP_EXISTS                  = CURLE_REMOTE_FILE_EXISTS
const CURLE_HTTP_RANGE_ERROR             = CURLE_RANGE_ERROR
const CURLE_FTP_SSL_FAILED               = CURLE_USE_SSL_FAILED
const CURLE_OPERATION_TIMEOUTED          = CURLE_OPERATION_TIMEDOUT
const CURLE_HTTP_NOT_FOUND               = CURLE_HTTP_RETURNED_ERROR
const CURLE_HTTP_PORT_FAILED             = CURLE_INTERFACE_FAILED
const CURLE_FTP_COULDNT_STOR_FILE        = CURLE_UPLOAD_FAILED
const CURLE_FTP_PARTIAL_FILE             = CURLE_PARTIAL_FILE
const CURLE_FTP_BAD_DOWNLOAD_RESUME      = CURLE_BAD_DOWNLOAD_RESUME
const CURLE_ALREADY_COMPLETE             = 99999
const CURLOPT_FILE                       = CURLOPT_WRITEDATA
const CURLOPT_INFILE                     = CURLOPT_READDATA
const CURLOPT_WRITEHEADER                = CURLOPT_HEADERDATA
const CURLOPT_WRITEINFO                  = CURLOPT_OBSOLETE40
const CURLOPT_CLOSEPOLICY                = CURLOPT_OBSOLETE72
const CURLAUTH_NONE                      = (0)
const CURLAUTH_BASIC                     = ((1)<<0)
const CURLAUTH_DIGEST                    = ((1)<<1)
const CURLAUTH_NEGOTIATE                 = ((1)<<2)
const CURLAUTH_GSSNEGOTIATE              = CURLAUTH_NEGOTIATE
const CURLAUTH_GSSAPI                    = CURLAUTH_NEGOTIATE
const CURLAUTH_NTLM                      = ((1)<<3)
const CURLAUTH_DIGEST_IE                 = ((1)<<4)
const CURLAUTH_NTLM_WB                   = ((1)<<5)
const CURLAUTH_BEARER                    = ((1)<<6)
const CURLAUTH_ONLY                      = ((1)<<31)
const CURLAUTH_ANY                       = (~CURLAUTH_DIGEST_IE)
const CURLAUTH_ANYSAFE                   = (~(CURLAUTH_BASIC|CURLAUTH_DIGEST_IE))
const CURLSSH_AUTH_ANY                   = ~0
const CURLSSH_AUTH_NONE                  = 0
const CURLSSH_AUTH_PUBLICKEY             = (1<<0)
const CURLSSH_AUTH_PASSWORD              = (1<<1)
const CURLSSH_AUTH_HOST                  = (1<<2)
const CURLSSH_AUTH_KEYBOARD              = (1<<3)
const CURLSSH_AUTH_AGENT                 = (1<<4)
const CURLSSH_AUTH_GSSAPI                = (1<<5)
const CURLSSH_AUTH_DEFAULT               = CURLSSH_AUTH_ANY
const CURLGSSAPI_DELEGATION_NONE         = 0
const CURLGSSAPI_DELEGATION_POLICY_FLAG  = (1<<0)
const CURLGSSAPI_DELEGATION_FLAG         = (1<<1)
const CURL_ERROR_SIZE                    = 256
const CURLSSLOPT_ALLOW_BEAST             = (1<<0)
const CURLSSLOPT_NO_REVOKE               = (1<<1)
const CURL_HET_DEFAULT                   = Clong(200)
const CURLFTPSSL_NONE                    = CURLUSESSL_NONE
const CURLFTPSSL_TRY                     = CURLUSESSL_TRY
const CURLFTPSSL_CONTROL                 = CURLUSESSL_CONTROL
const CURLFTPSSL_ALL                     = CURLUSESSL_ALL
const CURLFTPSSL_LAST                    = CURLUSESSL_LAST
const CURLHEADER_UNIFIED                 = 0
const CURLHEADER_SEPARATE                = (1<<0)
const CURLPROTO_HTTP                     = (1<<0)
const CURLPROTO_HTTPS                    = (1<<1)
const CURLPROTO_FTP                      = (1<<2)
const CURLPROTO_FTPS                     = (1<<3)
const CURLPROTO_SCP                      = (1<<4)
const CURLPROTO_SFTP                     = (1<<5)
const CURLPROTO_TELNET                   = (1<<6)
const CURLPROTO_LDAP                     = (1<<7)
const CURLPROTO_LDAPS                    = (1<<8)
const CURLPROTO_DICT                     = (1<<9)
const CURLPROTO_FILE                     = (1<<10)
const CURLPROTO_TFTP                     = (1<<11)
const CURLPROTO_IMAP                     = (1<<12)
const CURLPROTO_IMAPS                    = (1<<13)
const CURLPROTO_POP3                     = (1<<14)
const CURLPROTO_POP3S                    = (1<<15)
const CURLPROTO_SMTP                     = (1<<16)
const CURLPROTO_SMTPS                    = (1<<17)
const CURLPROTO_RTSP                     = (1<<18)
const CURLPROTO_RTMP                     = (1<<19)
const CURLPROTO_RTMPT                    = (1<<20)
const CURLPROTO_RTMPE                    = (1<<21)
const CURLPROTO_RTMPTE                   = (1<<22)
const CURLPROTO_RTMPS                    = (1<<23)
const CURLPROTO_RTMPTS                   = (1<<24)
const CURLPROTO_GOPHER                   = (1<<25)
const CURLPROTO_SMB                      = (1<<26)
const CURLPROTO_SMBS                     = (1<<27)
const CURLPROTO_ALL                      = (~0)
const CURLOPTTYPE_LONG                   = 0
const CURLOPTTYPE_OBJECTPOINT            = 10000
const CURLOPTTYPE_STRINGPOINT            = 10000
const CURLOPTTYPE_FUNCTIONPOINT          = 20000
const CURLOPTTYPE_OFF_T                  = 30000
const CURLOPT_XFERINFODATA               = CURLOPT_PROGRESSDATA
const CURLOPT_SERVER_RESPONSE_TIMEOUT    = CURLOPT_FTP_RESPONSE_TIMEOUT
const CURLOPT_POST301                    = CURLOPT_POSTREDIR
const CURLOPT_SSLKEYPASSWD               = CURLOPT_KEYPASSWD
const CURLOPT_FTPAPPEND                  = CURLOPT_APPEND
const CURLOPT_FTPLISTONLY                = CURLOPT_DIRLISTONLY
const CURLOPT_FTP_SSL                    = CURLOPT_USE_SSL
const CURLOPT_SSLCERTPASSWD              = CURLOPT_KEYPASSWD
const CURLOPT_KRB4LEVEL                  = CURLOPT_KRBLEVEL
const CURL_IPRESOLVE_WHATEVER            = 0
const CURL_IPRESOLVE_V4                  = 1
const CURL_IPRESOLVE_V6                  = 2
const CURLOPT_RTSPHEADER                 = CURLOPT_HTTPHEADER
const CURL_HTTP_VERSION_2                = CURL_HTTP_VERSION_2_0
const CURL_REDIR_GET_ALL                 = 0
const CURL_REDIR_POST_301                = 1
const CURL_REDIR_POST_302                = 2
const CURL_REDIR_POST_303                = 4
const CURL_REDIR_POST_ALL                = (CURL_REDIR_POST_301|CURL_REDIR_POST_302|CURL_REDIR_POST_303)
const CURL_ZERO_TERMINATED               = -1
const CURLINFO_STRING                    = 0x100000
const CURLINFO_LONG                      = 0x200000
const CURLINFO_DOUBLE                    = 0x300000
const CURLINFO_SLIST                     = 0x400000
const CURLINFO_PTR                       = 0x400000
const CURLINFO_SOCKET                    = 0x500000
const CURLINFO_OFF_T                     = 0x600000
const CURLINFO_MASK                      = 0x0fffff
const CURLINFO_TYPEMASK                  = 0xf00000
const CURLINFO_HTTP_CODE                 = CURLINFO_RESPONSE_CODE
const CURL_GLOBAL_SSL                    = (1<<0)
const CURL_GLOBAL_WIN32                  = (1<<1)
const CURL_GLOBAL_ALL                    = (CURL_GLOBAL_SSL|CURL_GLOBAL_WIN32)
const CURL_GLOBAL_NOTHING                = 0
const CURL_GLOBAL_DEFAULT                = CURL_GLOBAL_ALL
const CURL_GLOBAL_ACK_EINTR              = (1<<2)
const CURLVERSION_NOW                    = CURLVERSION_FIFTH
const CURL_VERSION_IPV6                  = (1<<0)
const CURL_VERSION_KERBEROS4             = (1<<1)
const CURL_VERSION_SSL                   = (1<<2)
const CURL_VERSION_LIBZ                  = (1<<3)
const CURL_VERSION_NTLM                  = (1<<4)
const CURL_VERSION_GSSNEGOTIATE          = (1<<5)
const CURL_VERSION_DEBUG                 = (1<<6)
const CURL_VERSION_ASYNCHDNS             = (1<<7)
const CURL_VERSION_SPNEGO                = (1<<8)
const CURL_VERSION_LARGEFILE             = (1<<9)
const CURL_VERSION_IDN                   = (1<<10)
const CURL_VERSION_SSPI                  = (1<<11)
const CURL_VERSION_CONV                  = (1<<12)
const CURL_VERSION_CURLDEBUG             = (1<<13)
const CURL_VERSION_TLSAUTH_SRP           = (1<<14)
const CURL_VERSION_NTLM_WB               = (1<<15)
const CURL_VERSION_HTTP2                 = (1<<16)
const CURL_VERSION_GSSAPI                = (1<<17)
const CURL_VERSION_KERBEROS5             = (1<<18)
const CURL_VERSION_UNIX_SOCKETS          = (1<<19)
const CURL_VERSION_PSL                   = (1<<20)
const CURL_VERSION_HTTPS_PROXY           = (1<<21)
const CURL_VERSION_MULTI_SSL             = (1<<22)
const CURL_VERSION_BROTLI                = (1<<23)
const CURLPAUSE_RECV                     = (1<<0)
const CURLPAUSE_RECV_CONT                = (0)
const CURLPAUSE_SEND                     = (1<<2)
const CURLPAUSE_SEND_CONT                = (0)
const CURLPAUSE_ALL                      = (CURLPAUSE_RECV|CURLPAUSE_SEND)
const CURLPAUSE_CONT                     = (CURLPAUSE_RECV_CONT|CURLPAUSE_SEND_CONT)
const CURLM_CALL_MULTI_SOCKET            = CURLM_CALL_MULTI_PERFORM
const CURLPIPE_NOTHING                   = Clong(0)
const CURLPIPE_HTTP1                     = Clong(1)
const CURLPIPE_MULTIPLEX                 = Clong(2)
const CURL_WAIT_POLLIN                   = 0x0001
const CURL_WAIT_POLLPRI                  = 0x0002
const CURL_WAIT_POLLOUT                  = 0x0004
const CURL_POLL_NONE                     = 0
const CURL_POLL_IN                       = 1
const CURL_POLL_OUT                      = 2
const CURL_POLL_INOUT                    = 3
const CURL_POLL_REMOVE                   = 4
const CURL_SOCKET_TIMEOUT                = CURL_SOCKET_BAD
const CURL_CSELECT_IN                    = 0x01
const CURL_CSELECT_OUT                   = 0x02
const CURL_CSELECT_ERR                   = 0x04
const CURL_PUSH_OK                       = 0
const CURL_PUSH_DENY                     = 1
