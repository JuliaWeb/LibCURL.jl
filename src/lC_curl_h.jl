# Julia wrapper for header: /usr/local/opt/curl/include/curl/curl.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function curl_strequal(s1, s2)
    ccall((:curl_strequal, libcurl), Cint, (Ptr{UInt8}, Ptr{UInt8}), s1, s2)
end

function curl_strnequal(s1, s2, n)
    ccall((:curl_strnequal, libcurl), Cint, (Ptr{UInt8}, Ptr{UInt8}, Csize_t), s1, s2, n)
end

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
    ccall((:curl_mime_name, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{UInt8}), part, name)
end

function curl_mime_filename(part, filename)
    ccall((:curl_mime_filename, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{UInt8}), part, filename)
end

function curl_mime_type(part, mimetype)
    ccall((:curl_mime_type, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{UInt8}), part, mimetype)
end

function curl_mime_encoder(part, encoding)
    ccall((:curl_mime_encoder, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{UInt8}), part, encoding)
end

function curl_mime_data(part, data, datasize)
    ccall((:curl_mime_data, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{UInt8}, Csize_t), part, data, datasize)
end

function curl_mime_filedata(part, filename)
    ccall((:curl_mime_filedata, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{UInt8}), part, filename)
end

function curl_mime_data_cb(part, datasize, readfunc, seekfunc, freefunc, arg)
    ccall((:curl_mime_data_cb, libcurl), CURLcode, (Ptr{curl_mimepart}, curl_off_t, curl_read_callback, curl_seek_callback, curl_free_callback, Ptr{Cvoid}), part, datasize, readfunc, seekfunc, freefunc, arg)
end

function curl_mime_subparts(part, subparts)
    ccall((:curl_mime_subparts, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{curl_mime}), part, subparts)
end

function curl_mime_headers(part, headers, take_ownership)
    ccall((:curl_mime_headers, libcurl), CURLcode, (Ptr{curl_mimepart}, Ptr{Cvoid}, Cint), part, headers, take_ownership)
end

function curl_formget(form, arg, append)
    ccall((:curl_formget, libcurl), Cint, (Ptr{Cvoid}, Ptr{Cvoid}, curl_formget_callback), form, arg, append)
end

function curl_formfree(form)
    ccall((:curl_formfree, libcurl), Cvoid, (Ptr{Cvoid},), form)
end

function curl_getenv(variable)
    ccall((:curl_getenv, libcurl), Ptr{UInt8}, (Ptr{UInt8},), variable)
end

function curl_version()
    ccall((:curl_version, libcurl), Ptr{UInt8}, ())
end

function curl_easy_escape(handle, string, length)
    ccall((:curl_easy_escape, libcurl), Ptr{UInt8}, (Ptr{CURL}, Ptr{UInt8}, Cint), handle, string, length)
end

function curl_escape(string, length)
    ccall((:curl_escape, libcurl), Ptr{UInt8}, (Ptr{UInt8}, Cint), string, length)
end

function curl_easy_unescape(handle, string, length, outlength)
    ccall((:curl_easy_unescape, libcurl), Ptr{UInt8}, (Ptr{CURL}, Ptr{UInt8}, Cint, Ptr{Cint}), handle, string, length, outlength)
end

function curl_unescape(string, length)
    ccall((:curl_unescape, libcurl), Ptr{UInt8}, (Ptr{UInt8}, Cint), string, length)
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

function curl_global_sslset(id, name, avail)
    ccall((:curl_global_sslset, libcurl), CURLsslset, (curl_sslbackend, Ptr{UInt8}, Ptr{Ptr{Ptr{curl_ssl_backend}}}), id, name, avail)
end

function curl_slist_append(arg1, arg2)
    ccall((:curl_slist_append, libcurl), Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{UInt8}), arg1, arg2)
end

function curl_slist_free_all(arg1)
    ccall((:curl_slist_free_all, libcurl), Cvoid, (Ptr{Cvoid},), arg1)
end

function curl_getdate(p, unused)
    ccall((:curl_getdate, libcurl), time_t, (Ptr{UInt8}, Ptr{time_t}), p, unused)
end

function curl_share_init()
    ccall((:curl_share_init, libcurl), Ptr{CURLSH}, ())
end

function curl_share_setopt(handle, opt, param)
    ccall((:curl_share_setopt, libcurl), CURLSHcode, (Ptr{CURLSH}, CURLSHoption, Any...), handle, opt, param)
end

function curl_share_cleanup(arg1)
    ccall((:curl_share_cleanup, libcurl), CURLSHcode, (Ptr{CURLSH},), arg1)
end

function curl_version_info(arg1)
    ccall((:curl_version_info, libcurl), Ptr{curl_version_info_data}, (CURLversion,), arg1)
end

function curl_easy_strerror(arg1)
    ccall((:curl_easy_strerror, libcurl), Ptr{UInt8}, (CURLcode,), arg1)
end

function curl_share_strerror(arg1)
    ccall((:curl_share_strerror, libcurl), Ptr{UInt8}, (CURLSHcode,), arg1)
end

function curl_easy_pause(handle, bitmask)
    ccall((:curl_easy_pause, libcurl), CURLcode, (Ptr{CURL}, Cint), handle, bitmask)
end

function curl_easy_init()
    ccall((:curl_easy_init, libcurl), Ptr{CURL}, ())
end

function curl_easy_setopt(handle, opt, param)
    ccall((:curl_easy_setopt, libcurl), CURLcode, (Ptr{CURL}, CURLoption, Any...), handle, opt, param)
end

function curl_easy_perform(curl)
    ccall((:curl_easy_perform, libcurl), CURLcode, (Ptr{CURL},), curl)
end

function curl_easy_cleanup(curl)
    ccall((:curl_easy_cleanup, libcurl), Cvoid, (Ptr{CURL},), curl)
end

function curl_easy_getinfo(handle, info, arg)
    ccall((:curl_easy_getinfo, libcurl), CURLcode, (Ptr{CURL}, CURLINFO, Any...), handle, info, arg)
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
    ccall((:curl_multi_wait, libcurl), CURLMcode, (Ptr{CURLM}, Ptr{Cvoid}, UInt32, Cint, Ptr{Cint}), multi_handle, extra_fds, extra_nfds, timeout_ms, ret)
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
    ccall((:curl_multi_strerror, libcurl), Ptr{UInt8}, (CURLMcode,), arg1)
end

function curl_multi_socket(multi_handle, s, running_handles)
    ccall((:curl_multi_socket, libcurl), CURLMcode, (Ptr{CURLM}, curl_socket_t, Ptr{Cint}), multi_handle, s, running_handles)
end

function curl_multi_socket_action(multi_handle, s, ev_bitmask, running_handles)
    ccall((:curl_multi_socket_action, libcurl), CURLMcode, (Ptr{CURLM}, curl_socket_t, Cint, Ptr{Cint}), multi_handle, s, ev_bitmask, running_handles)
end

function curl_multi_socket_all(multi_handle, running_handles)
    ccall((:curl_multi_socket_all, libcurl), CURLMcode, (Ptr{CURLM}, Ptr{Cint}), multi_handle, running_handles)
end

function curl_multi_timeout(multi_handle, milliseconds)
    ccall((:curl_multi_timeout, libcurl), CURLMcode, (Ptr{CURLM}, Ptr{Clong}), multi_handle, milliseconds)
end

function curl_multi_setopt(multi_handle, opt, param)
    ccall((:curl_multi_setopt, libcurl), CURLMcode, (Ptr{CURLM}, CURLMoption, Any...), multi_handle, opt, param)
end

function curl_multi_assign(multi_handle, sockfd, sockp)
    ccall((:curl_multi_assign, libcurl), CURLMcode, (Ptr{CURLM}, curl_socket_t, Ptr{Cvoid}), multi_handle, sockfd, sockp)
end

function curl_pushheader_bynum(h, num)
    ccall((:curl_pushheader_bynum, libcurl), Ptr{UInt8}, (Ptr{Cvoid}, Csize_t), h, num)
end

function curl_pushheader_byname(h, name)
    ccall((:curl_pushheader_byname, libcurl), Ptr{UInt8}, (Ptr{Cvoid}, Ptr{UInt8}), h, name)
end
