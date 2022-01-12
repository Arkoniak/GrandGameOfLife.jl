module TestSimulation
using GrandGameOfLife
using Test

@testset "flashlight" begin
    state = to_cell.([(10, 10), (9, 10), (11, 10)])
    state = LifeCells(state)

    newstate = makestep(state)
    @test !has(newstate, to_cell(9, 10))
    @test !has(newstate, to_cell(11, 10))
    @test has(newstate, to_cell(10, 10))
    @test has(newstate, to_cell(10, 11))
    @test has(newstate, to_cell(10, 9))
end

end # module
