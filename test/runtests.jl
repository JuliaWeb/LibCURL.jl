using LibCURL

# For lack of anything better, just run HTTPClient's tests.
# They should exercise a large number of LibCURL features.
# Until HTTPClient is bumped, that requires using master of
# HTTPClient. Careful running this test locally!
Pkg.checkout("HTTPClient")
Pkg.test("HTTPClient",coverage=true)