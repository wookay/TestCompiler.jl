module test_base_reduce

using Test

# from julia/base/indices.jl
#      julia/base/reduce.jl
#      julia/base/reducedim.jl

count
last

@test count(isodd, 5:9) == 3

@test last(5:9) == 9

@test last(5:9, 0) == 10:9
@test last(5:9, 1) == 9:9
@test last(5:9, 2) == 8:9
@test last(5:9, 3) == 7:9

end # module test_base_reduce
