module test_base_anyall

using Test
using InteractiveUtils: subtypes

# from julia/base/anyall.jl
#      julia/base/missing.jl

@test length(subtypes(Any)) >= 460
@test any isa Function

@test any([missing]) === all([missing])=== missing
@test any([true]) === all([true]) === true
@test any([false]) === all([false])=== false

@test any([]) === false
@test any([false, true, missing]) === true
@test any([false, false, missing]) === missing
@test any([true, true, missing]) === true

@test all([]) === true
@test all([missing]) === missing
@test all([false, true, missing]) === false
@test all([false, false, missing]) === false
@test all([true, true, missing]) === missing

@test missing isa Missing

end # module test_base_anyall
