using httpc

RB = "http://requestb.in/1f9lxb01"

r=httpc.get(RB * "?test=1")
println("Test 1 passed, http_code : " * string(r.http_code))

r=httpc.get(RB, querydict={:test => 1.1, :Hello => "\"World\"", "_rt" => "&!@#%"})
println("Test 1.1 passed, http_code : " * string(r.http_code))

r=httpc.get(RB * "?test=2", timeout=3.0)
println("Test 2 passed, http_code : " * string(r.http_code))

r=httpc.put(RB * "?test=3", "some text")
println("Test 3 passed, http_code : " * string(r.http_code))

r=httpc.put(RB, "some text", querydict={:test => 3.1, :Hello => "\"World\""})
println("Test 3.1 passed, http_code : " * string(r.http_code))

r=httpc.put_file(RB * "?test=4", "uploadfile.txt")
println("Test 4 passed, http_code : " * string(r.http_code))

r=httpc.post(RB * "?test=5", "[1,2]")
println("Test 5 passed, http_code : " * string(r.http_code))

r=httpc.post(RB, "[1,2]", querydict={:test => 5.1, :Hello => "\"World\""})
println("Test 5.1 passed, http_code : " * string(r.http_code))

r=httpc.post(RB * "?test=6", "[1,2]", content_type="application/json")
println("Test 6 passed, http_code : " * string(r.http_code))

r=httpc.post_file(RB * "?test=7", "uploadfile.txt", content_type="text/plain")
println("Test 7 passed, http_code : " * string(r.http_code))

r=httpc.post_file(RB * "?test=8", "uploadfile.txt")
println("Test 8 passed, http_code : " * string(r.http_code))

r=httpc.head(RB * "?test=9")
println("Test 9 passed, http_code : " * string(r.http_code))

r=httpc.trace(RB * "?test=10")
println("Test 10 passed, http_code : " * string(r.http_code))

r=httpc.delete(RB * "?test=11")
println("Test 11 passed, http_code : " * string(r.http_code))

r=httpc.options(RB * "?test=12")
println("Test 12 passed, http_code : " * string(r.http_code))

function waitnexec (id)
    tname = "async" * string(id)
    global trigger
    while (trigger != :go)
        sleep(0.001)
    end
    r=httpc.get(RB * "?test=" * tname)
    println("Test " * tname * " passed, http_code : " * string(r.http_code))
end

# Run 100 requests in parallel asynchronously
trigger = :wait
rrefs = [remotecall(1, waitnexec, i) for i in 1:100]

trigger = :go
# wait for all of them to finish
for ref in rrefs
    wait(ref)
end

