# Julia wrapper for header: /usr/include/curl/curl.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Int32 curl_strequal (Ptr{Uint8}, Ptr{Uint8}) libcurl
@c Int32 curl_strnequal (Ptr{Uint8}, Ptr{Uint8}, size_t) libcurl
@c CURLFORMcode curl_formadd (Ptr{Ptr{Void}}, Ptr{Ptr{Void}}) libcurl
@c Int32 curl_formget (Ptr{Void}, Ptr{None}, curl_formget_callback) libcurl
@c None curl_formfree (Ptr{Void},) libcurl
@c Ptr{Uint8} curl_getenv (Ptr{Uint8},) libcurl
@c Ptr{Uint8} curl_version () libcurl
@c Ptr{Uint8} curl_easy_escape (Ptr{CURL}, Ptr{Uint8}, Int32) libcurl
@c Ptr{Uint8} curl_escape (Ptr{Uint8}, Int32) libcurl
@c Ptr{Uint8} curl_easy_unescape (Ptr{CURL}, Ptr{Uint8}, Int32, Ptr{Int32}) libcurl
@c Ptr{Uint8} curl_unescape (Ptr{Uint8}, Int32) libcurl
@c None curl_free (Ptr{None},) libcurl
@c CURLcode curl_global_init (Int32,) libcurl
@c CURLcode curl_global_init_mem (Int32, curl_malloc_callback, curl_free_callback, curl_realloc_callback, curl_strdup_callback, curl_calloc_callback) libcurl
@c None curl_global_cleanup () libcurl
@c Ptr{Void} curl_slist_append (Ptr{Void}, Ptr{Uint8}) libcurl
@c None curl_slist_free_all (Ptr{Void},) libcurl
@c time_t curl_getdate (Ptr{Uint8}, Ptr{time_t}) libcurl
@c Ptr{CURLSH} curl_share_init () libcurl
@c CURLSHcode curl_share_setopt (Ptr{CURLSH}, CURLSHoption) libcurl
@c CURLSHcode curl_share_cleanup (Ptr{CURLSH},) libcurl
@c Ptr{curl_version_info_data} curl_version_info (CURLversion,) libcurl
@c Ptr{Uint8} curl_easy_strerror (CURLcode,) libcurl
@c Ptr{Uint8} curl_share_strerror (CURLSHcode,) libcurl
@c CURLcode curl_easy_pause (Ptr{CURL}, Int32) libcurl
@c Ptr{CURL} curl_easy_init () libcurl
@c CURLcode curl_easy_setopt (Ptr{CURL}, CURLoption) libcurl
@c CURLcode curl_easy_perform (Ptr{CURL},) libcurl
@c None curl_easy_cleanup (Ptr{CURL},) libcurl
@c CURLcode curl_easy_getinfo (Ptr{CURL}, CURLINFO) libcurl
@c Ptr{CURL} curl_easy_duphandle (Ptr{CURL},) libcurl
@c None curl_easy_reset (Ptr{CURL},) libcurl
@c CURLcode curl_easy_recv (Ptr{CURL}, Ptr{None}, size_t, Ptr{size_t}) libcurl
@c CURLcode curl_easy_send (Ptr{CURL}, Ptr{None}, size_t, Ptr{size_t}) libcurl
@c Ptr{CURLM} curl_multi_init () libcurl
@c CURLMcode curl_multi_add_handle (Ptr{CURLM}, Ptr{CURL}) libcurl
@c CURLMcode curl_multi_remove_handle (Ptr{CURLM}, Ptr{CURL}) libcurl
@c CURLMcode curl_multi_fdset (Ptr{CURLM}, Ptr{fd_set}, Ptr{fd_set}, Ptr{fd_set}, Ptr{Int32}) libcurl
@c CURLMcode curl_multi_perform (Ptr{CURLM}, Ptr{Int32}) libcurl
@c CURLMcode curl_multi_cleanup (Ptr{CURLM},) libcurl
@c Ptr{CURLMsg} curl_multi_info_read (Ptr{CURLM}, Ptr{Int32}) libcurl
@c Ptr{Uint8} curl_multi_strerror (CURLMcode,) libcurl
@c CURLMcode curl_multi_socket (Ptr{CURLM}, curl_socket_t, Ptr{Int32}) libcurl
@c CURLMcode curl_multi_socket_action (Ptr{CURLM}, curl_socket_t, Int32, Ptr{Int32}) libcurl
@c CURLMcode curl_multi_socket_all (Ptr{CURLM}, Ptr{Int32}) libcurl
@c CURLMcode curl_multi_timeout (Ptr{CURLM}, Ptr{Int32}) libcurl
@c CURLMcode curl_multi_setopt (Ptr{CURLM}, CURLMoption) libcurl
@c CURLMcode curl_multi_assign (Ptr{CURLM}, curl_socket_t, Ptr{None}) libcurl

