using libCURL.HTTPC
using JSON
using Base.Test

# get a request bin name
r=HTTPC.post("http://requestb.in/api/v1/bins", "")
@test r.http_code == 200

jdict = JSON.parse(r.body)
@test haskey(jdict, "name")

RB = "http://requestb.in/" * jdict["name"]

r=HTTPC.get(RB * "?test=1")
@test r.http_code == 200
println("Test 1 passed, http_code : " * string(r.http_code))

r=HTTPC.get(RB, querydict={:test => 1.1, :Hello => "\"World\"", "_rt" => "&!@#%"})
@test r.http_code == 200
println("Test 1.1 passed, http_code : " * string(r.http_code))

rr=HTTPC.get_async(RB, querydict={:test => 1.2, :Hello => "\"World\"", "_rt" => "&!@#%"})
r = fetch(rr)
@test r.http_code == 200
println("Test 1.2 passed, http_code : " * string(r.http_code))


r=HTTPC.get(RB * "?test=2", timeout=60.0)
@test r.http_code == 200
println("Test 2 passed, http_code : " * string(r.http_code))

@test_fails HTTPC.get(RB * "?test=low_timeout", timeout=0.001)

r=HTTPC.put(RB * "?test=3", "some text")
@test r.http_code == 200
println("Test 3 passed, http_code : " * string(r.http_code))

r=HTTPC.put(RB, "some text", querydict={:test => 3.1, :Hello => "\"World\""})
@test r.http_code == 200
println("Test 3.1 passed, http_code : " * string(r.http_code))

rr=HTTPC.put_async(RB, "some text", querydict={:test => 3.2, :Hello => "\"World\""})
r = fetch(rr)
@test r.http_code == 200
println("Test 3.2 passed, http_code : " * string(r.http_code))


r=HTTPC.put_file(RB * "?test=4", "uploadfile.txt")
@test r.http_code == 200
println("Test 4 passed, http_code : " * string(r.http_code))

r=HTTPC.post(RB * "?test=5", "[1,2]")
@test r.http_code == 200
println("Test 5 passed, http_code : " * string(r.http_code))

r=HTTPC.post(RB, "[1,2]", querydict={:test => 5.1, :Hello => "\"World\""})
@test r.http_code == 200
println("Test 5.1 passed, http_code : " * string(r.http_code))

r=HTTPC.post(RB * "?test=6", "[1,2]", content_type="application/json")
@test r.http_code == 200
println("Test 6 passed, http_code : " * string(r.http_code))

rr=HTTPC.post_async(RB * "?test=6.1", "[1,2]", content_type="application/json")
r = fetch(rr)
@test r.http_code == 200
println("Test 6.1 passed, http_code : " * string(r.http_code))


r=HTTPC.post_file(RB * "?test=7", "uploadfile.txt", content_type="text/plain")
@test r.http_code == 200
println("Test 7 passed, http_code : " * string(r.http_code))

r=HTTPC.post_file(RB * "?test=8", "uploadfile.txt")
@test r.http_code == 200
println("Test 8 passed, http_code : " * string(r.http_code))

rr=HTTPC.post_file_async(RB * "?test=8.1", "uploadfile.txt")
r = fetch(rr)
@test r.http_code == 200
println("Test 8.1 passed, http_code : " * string(r.http_code))

r=HTTPC.head(RB * "?test=9")
@test r.http_code == 200
println("Test 9 passed, http_code : " * string(r.http_code))

rr=HTTPC.head_async(RB * "?test=9.1")
r = fetch(rr)
@test r.http_code == 200
println("Test 9.1 passed, http_code : " * string(r.http_code))

r=HTTPC.trace(RB * "?test=10")
println("Test 10 passed, http_code : " * string(r.http_code))
#@test r.http_code == 200

r=HTTPC.delete(RB * "?test=11")
println("Test 11 passed, http_code : " * string(r.http_code))
@test r.http_code == 200

r=HTTPC.options(RB * "?test=12")
println("Test 12 passed, http_code : " * string(r.http_code))
@test r.http_code == 200

function waitnexec (id)
    tname = "async" * string(id)
    global trigger
    while (trigger != :go)
        sleep(0.001)
    end
    r=HTTPC.get(RB * "?test=" * tname)
    println("Test " * tname * " passed, http_code : " * string(r.http_code))
    r
end

# Run 100 requests in parallel asynchronously
trigger = :wait
rrefs = [remotecall(1, waitnexec, i) for i in 1:100]

trigger = :go
# wait for all of them to finish
for ref in rrefs
    wait(ref)
end

