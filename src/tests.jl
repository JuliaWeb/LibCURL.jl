using httpc

r=httpc.get("http://requestb.in/uemh8due?test=1")
println("Test 1 passed, http_code : " * string(r.http_code))

r=httpc.get("http://requestb.in/uemh8due?test=2", timeout=3.0)
println("Test 2 passed, http_code : " * string(r.http_code))

r=httpc.put("http://requestb.in/uemh8due?test=3", "some text")
println("Test 3 passed, http_code : " * string(r.http_code))
r=httpc.put_file("http://requestb.in/uemh8due?test=4", "uploadfile.txt")
println("Test 4 passed, http_code : " * string(r.http_code))

r=httpc.post("http://requestb.in/uemh8due?test=5", "[1,2]")
println("Test 5 passed, http_code : " * string(r.http_code))
r=httpc.post("http://requestb.in/uemh8due?test=6", "[1,2]", content_type="application/json")
println("Test 6 passed, http_code : " * string(r.http_code))

r=httpc.post_file("http://requestb.in/uemh8due?test=7", "uploadfile.txt", content_type="text/plain")
println("Test 7 passed, http_code : " * string(r.http_code))

r=httpc.post_file("http://requestb.in/uemh8due?test=8", "uploadfile.txt")
println("Test 8 passed, http_code : " * string(r.http_code))

r=httpc.head("http://requestb.in/uemh8due?test=9")
println("Test 9 passed, http_code : " * string(r.http_code))

r=httpc.trace("http://requestb.in/uemh8due?test=10")
println("Test 10 passed, http_code : " * string(r.http_code))

r=httpc.delete("http://requestb.in/uemh8due?test=11")
println("Test 11 passed, http_code : " * string(r.http_code))

r=httpc.options("http://requestb.in/uemh8due?test=12")
println("Test 12 passed, http_code : " * string(r.http_code))
