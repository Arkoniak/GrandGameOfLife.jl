module BenchStep
using BenchmarkTools
using GrandGameOfLife
using Random

suite = BenchmarkGroup()

Random.seed!(2020)
state = create_initial_state(1000, 1000, 0.7)

suite["step"] = @benchmarkable makestep($state)

end # module

BenchDistance.suite
