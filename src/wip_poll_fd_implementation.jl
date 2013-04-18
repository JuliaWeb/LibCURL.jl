

###############################################################################
# Code to use poll_fd() instead of sleep() whenever it becomes available
###############################################################################


type MultiCtxt
    s::curl_socket_t    # Socket
    events::Cint # Events to poll for
    timeout_ms::Cint
end


const  UV_READABLE = 1
const  UV_WRITABLE = 2


function curl_socket_cb(curl::Ptr{Void}, s::Cint, action::Cint, p_muctxt::Ptr{Void}, sctxt::Ptr{Void})
    if (action == CURL_POLL_REMOVE)
        # Out-of-order socket fds were causing problems in the case of HTTP redirects
        return 0
    end

    muctxt = unsafe_pointer_to_objref(p_muctxt)

    muctxt.s = s

    if (action == CURL_POLL_NONE)
        muctxt.events = 0

    elseif (action == CURL_POLL_IN)
        muctxt.events = UV_READABLE

    elseif (action == CURL_POLL_OUT)
        muctxt.events = UV_WRITABLE

    elseif (action == CURL_POLL_INOUT)
        muctxt.events = UV_READABLE | UV_WRITABLE

    end

    return 0
end

c_curl_socket_cb = cfunction(curl_socket_cb, Cint, (Ptr{Void}, Cint, Cint, Ptr{Void}, Ptr{Void}))



function curl_multi_timer_cb(curlm::Ptr{Void}, timeout_ms::Clong, p_muctxt::Ptr{Void})
    muctxt = unsafe_pointer_to_objref(p_muctxt)
    muctxt.timeout_ms = timeout_ms

    println("Requested timeout value : " * string(muctxt.timeout_ms))

    return 0
end

c_curl_multi_timer_cb = cfunction(curl_multi_timer_cb, Cint, (Ptr{Void}, Clong, Ptr{Void}))

immutable CURLMsg2
  msg::CURLMSG
  easy_handle::Ptr{CURL}
  data::Ptr{Any}
end

function get2(url, timeout)
    curlm = curl_multi_init()
    curl = 0
    response = nothing

    if (curlm == 0) error("Unable to initialize curl_multi_init()") end

#     try
        (curl, response) = setup_easy_get(url)

        cmc = curl_multi_add_handle(curlm, curl)
        if(cmc != CURLM_OK) error ("curl_multi_add_handle() failed: " * curl_multi_strerror(cmc)) end

        cmc = curl_multi_setopt(curlm, CURLMOPT_SOCKETFUNCTION, c_curl_socket_cb)
        if(cmc != CURLM_OK) error ("curl_multi_setopt() failed: " * curl_multi_strerror(cmc)) end

        cmc = curl_multi_setopt(curlm, CURLMOPT_TIMERFUNCTION, c_curl_multi_timer_cb)
        if(cmc != CURLM_OK) error ("curl_multi_setopt() failed: " * curl_multi_strerror(cmc)) end

        muctxt = MultiCtxt(0,0,0)
        p_muctxt = pointer_from_objref(muctxt)

        cmc = curl_multi_setopt(curlm, CURLMOPT_SOCKETDATA, p_muctxt)
        if(cmc != CURLM_OK) error ("curl_multi_setopt() failed: " * curl_multi_strerror(cmc)) end

        cmc = curl_multi_setopt(curlm, CURLMOPT_TIMERDATA, p_muctxt)
        if(cmc != CURLM_OK) error ("curl_multi_setopt() failed: " * curl_multi_strerror(cmc)) end

        # start the multi session
        n_active = Array(Int32,1)
        curl_multi_socket_action(curlm, CURL_SOCKET_TIMEOUT, 0, n_active)

        n_active[1] = 1
        now  = int(time())
        till = now + timeout + 1
        while (n_active[1] > 0) && ((till - now) > 0)

            evt_got = 0
            if (muctxt.events > 0)
                t1 = int64(time() * 1000)

                @unix_only fd::OS_FD = OS_FD(muctxt.s)
                @windows_only fd::OS_SOCKET = OS_SOCKET(muctxt.s)

                ps_ret = poll_fd(fd, muctxt.events, muctxt.timeout_ms)
                t2 = int64(time() * 1000)
                println("poll_ time : " * string(t2-t1) * " millis, args : " * string((muctxt.events, muctxt.timeout_ms)) * ", ps_ret : " * string(ps_ret))

                if (ps_ret[1] == :poll)
                    if (ps_ret[2] == 0)
                        evt_got = (((ps_ret[3] & UV_READABLE) == UV_READABLE ) ? CURL_CSELECT_IN : 0) | (((ps_ret[3] & UV_WRITEABLE) == UV_WRITEABLE ) ? CURL_CSELECT_OUT : 0)
                    else
                        evt_got = CURL_CSELECT_ERR
                    end
                 end

            else
                println("muctxt.events < 0")
                # Read and print any messages
                msgs_in_queue = Array(Int32,1)
                p_msg::Ptr{CURLMsg2} = curl_multi_info_read(curlm, msgs_in_queue)

                while (p_msg != C_NULL)
                    println("Messages left in Q : " * string(msgs_in_queue[1]))
                    msg = unsafe_ref(p_msg)
                    println("Got message, data : " * string(msg.msg) * "," * string(msg.data))
                    p_msg = curl_multi_info_read(curlm, msgs_in_queue)
                end
            end

            if (evt_got == 0)
                cmc = curl_multi_socket_action(curlm, CURL_SOCKET_TIMEOUT, 0, n_active)
            else
                cmc = curl_multi_socket_action(curlm, muctxt.s, evt_got, n_active)
            end
            if(cmc != CURLM_OK) error ("curl_multi_perform() failed: " * curl_multi_strerror(cmc)) end

            now  = int(time())
        end


        if (n_active[1] == 0)
            process_response(curl, response)
            curlm_cleanup(curlm, curl)
        else
            error ("request timed out")
        end

#     catch e
#         if (curl != 0)
#             curl_multi_remove_handle(curlm, curl)
#             curl_easy_cleanup(curl)
#         end
#
#         curl_multi_cleanup(curlm)
#         throw (string(e))
#     end

    response
end



