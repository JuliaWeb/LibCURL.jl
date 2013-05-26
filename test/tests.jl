using libCURL.HTTPC
using JSON
using Base.Test

# get a request bin name
r=HTTPC.post("http://requestb.in/api/v1/bins", "")
@test r.http_code == 200

jdict = JSON.parse(r.body)
@test haskey(jdict, "name")

RB = "http://requestb.in/" * jdict["name"]
println("URL : $RB")

r=HTTPC.get(RB * "?test=1")
@test r.http_code == 200
println("Test 1 passed, http_code : " * string(r.http_code))

r=HTTPC.get(RB * "?test=1.hdrs", RequestOptions(headers=[("Foo", "Bar"),("Baz", "Wux")]))
@test r.http_code == 200
println("Test 1.hdrs passed, http_code : " * string(r.http_code))

ostream=open("/tmp/google.txt", "w+")
r=HTTPC.get("http://www.google.com/", RequestOptions(ostream=ostream))
@test r.http_code == 200
println("Test 1.hdrs passed, http_code : " * string(r.http_code))
close(ostream)


rr=HTTPC.get(RB * "?test=1nb", RequestOptions(blocking=false))
r = fetch(rr)
@test r.http_code == 200
println("Test 1nb passed, http_code : " * string(r.http_code))

r=HTTPC.get(RB, RequestOptions(query_params=collect({:test => 1.1, :Hello => "\"World\"", "_rt" => "&!@#%"})))
@test r.http_code == 200
println("Test 1.1 passed, http_code : " * string(r.http_code))

rr=HTTPC.get(RB, RequestOptions(query_params=collect({:test => 1.2, :Hello => "\"World\"", "_rt" => "&!@#%"}), blocking=false))
r = fetch(rr)
@test r.http_code == 200
println("Test 1.2 passed, http_code : " * string(r.http_code))


r=HTTPC.get(RB * "?test=2", RequestOptions(request_timeout=60.0))
@test r.http_code == 200
println("Test 2 passed, http_code : " * string(r.http_code))

@test_fails HTTPC.get(RB * "?test=low_rto", RequestOptions(request_timeout=0.001))

r=HTTPC.put(RB * "?test=3", "some text")
@test r.http_code == 200
println("Test 3 passed, http_code : " * string(r.http_code))

rr=HTTPC.put(RB * "?test=3nb", "some text", RequestOptions(blocking=false))
r = fetch(rr)
@test r.http_code == 200
println("Test 3nb passed, http_code : " * string(r.http_code))

r=HTTPC.put(RB, "some text", RequestOptions(query_params=[(:test, 3.1), (:Hello, "\"World\"")]))
@test r.http_code == 200
println("Test 3.1 passed, http_code : " * string(r.http_code))

rr=HTTPC.put(RB, "some text", RequestOptions(query_params=[(:test, 3.2), (:Hello, "\"World\"")], blocking=false))
r = fetch(rr)
@test r.http_code == 200
println("Test 3.2 passed, http_code : " * string(r.http_code))


r=HTTPC.put(RB * "?test=4", (:file, "uploadfile.txt"))
@test r.http_code == 200
println("Test 4 passed, http_code : " * string(r.http_code))

r=HTTPC.post(RB * "?test=5", "[1,2]")
@test r.http_code == 200
println("Test 5 passed, http_code : " * string(r.http_code))

rr=HTTPC.post(RB * "?test=5nb", "[1,2]", RequestOptions(blocking=false))
r = fetch(rr)
@test r.http_code == 200
println("Test 5nb passed, http_code : " * string(r.http_code))


r=HTTPC.post(RB, "[1,2]", RequestOptions(query_params=[(:test, 5.1), (:Hello, "\"World\"")]))
@test r.http_code == 200
println("Test 5.1 passed, http_code : " * string(r.http_code))

r=HTTPC.post(RB * "?test=6", "[1,2]", RequestOptions(content_type="application/json"))
@test r.http_code == 200
println("Test 6 passed, http_code : " * string(r.http_code))

rr=HTTPC.post(RB * "?test=6.1", "[1,2]", RequestOptions(content_type="application/json", blocking=false))
r = fetch(rr)
@test r.http_code == 200
println("Test 6.1 passed, http_code : " * string(r.http_code))

r=HTTPC.post(RB * "?test=6.1", {"a" => 1, "b" => 2})
@test r.http_code == 200
println("Test 6.1 passed, http_code : " * string(r.http_code))

r=HTTPC.post(RB * "?test=6.1.1", [("a",1), ("b",2)])
@test r.http_code == 200
println("Test 6.1.1 passed, http_code : " * string(r.http_code))

ios = memio(32)
write(ios, "Hello World!")
seekstart(ios)
r=HTTPC.post(RB * "?test=6.2", ios)
@test r.http_code == 200
println("Test 6.2 passed, http_code : " * string(r.http_code))


r=HTTPC.post(RB * "?test=7", (:file, "uploadfile.txt"), RequestOptions(content_type="text/plain"))
@test r.http_code == 200
println("Test 7 passed, http_code : " * string(r.http_code))

r=HTTPC.post(RB * "?test=8", (:file, "uploadfile.txt"))
@test r.http_code == 200
println("Test 8 passed, http_code : " * string(r.http_code))

rr=HTTPC.post(RB * "?test=8.1", (:file, "uploadfile.txt"), RequestOptions(blocking=false))
r = fetch(rr)
@test r.http_code == 200
println("Test 8.1 passed, http_code : " * string(r.http_code))

r=HTTPC.head(RB * "?test=9")
@test r.http_code == 200
println("Test 9 passed, http_code : " * string(r.http_code))

rr=HTTPC.head(RB * "?test=9nb", RequestOptions(blocking=false))
r = fetch(rr)
@test r.http_code == 200
println("Test 9nb passed, http_code : " * string(r.http_code))


r=HTTPC.trace(RB * "?test=10")
println("Test 10 passed, http_code : " * string(r.http_code))
#@test r.http_code == 200

rr=HTTPC.trace(RB * "?test=10nb", RequestOptions(blocking=false))
r = fetch(rr)
println("Test 10nb passed, http_code : " * string(r.http_code))

r=HTTPC.delete(RB * "?test=11")
println("Test 11 passed, http_code : " * string(r.http_code))
@test r.http_code == 200

rr=HTTPC.delete(RB * "?test=11nb", RequestOptions(blocking=false))
r = fetch(rr)
println("Test 11nb passed, http_code : " * string(r.http_code))
@test r.http_code == 200

r=HTTPC.options(RB * "?test=12")
println("Test 12 passed, http_code : " * string(r.http_code))
@test r.http_code == 200

rr=HTTPC.options(RB * "?test=12nb", RequestOptions(blocking=false))
r = fetch(rr)
println("Test 12nb passed, http_code : " * string(r.http_code))
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

