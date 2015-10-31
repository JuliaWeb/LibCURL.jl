using LibCURL

# For lack of anything better, just run HTTPClient's tests.
# They should exercise a large number of LibCURL features.
Pkg.test("HTTPClient",coverage=true)
