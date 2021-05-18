using Pkg
using Test

@testset "LibCURL UUID" begin
    project_filename = joinpath(dirname(@__DIR__), "Project.toml")
    project = Pkg.TOML.parsefile(project_filename)
    uuid = project["uuid"]
    correct_uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
    @test uuid == correct_uuid
end
