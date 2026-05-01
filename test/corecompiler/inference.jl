module test_corecompiler_inference

using Test
using Core: Compiler as CC

# julia/Compiler/test/inference.jl
CC.argtypes_to_type
@test CC.argtypes_to_type(Any[])           === Tuple{}
@test CC.argtypes_to_type(Any[Int])        === Tuple{Int}
@test CC.argtypes_to_type(Any[Union{Int}]) === Tuple{Union{Int}}

f() = 42
Base.return_types
@test Base.return_types(f) == DataType[Int] == Any[Int]

Base.infer_return_type
Base.infer_return_type(f) === Int

end # module test_corecompiler_inference


module test_corecompiler_concrete_evaluate

using Test
using Core: Compiler as CC

CC.concrete_eval_eligible

# from julia/Compiler/test/inference.jl

@noinline function concrete_eval_eligible_if_false(x::Float64, n::Int, y::Bool)
    if y # this prevents initial concrete-evaluation
        println("x = ", x)
    end
    s = 0.0
    Base.@assume_effects :terminates_locally for i = 1:n
        s += sin(x)
    end
    return s
end

@test concrete_eval_eligible_if_false(2.,  1, false) == 1sin(2.)  == 0.9092974268256817
@test Base.infer_return_type() do
    Val(concrete_eval_eligible_if_false(2., 1, false) == 1sin(2.))
end == Val{true}

@test concrete_eval_eligible_if_false(42., 5, false) == 5sin(42.) == -4.582607739578169

if VERSION >= v"1.14.0-DEV.2108" # julia commit df12394092
    @test Base.infer_return_type() do
        Val(concrete_eval_eligible_if_false(42., 5, false) == 5sin(42.))
    end == Val{true}
else
    @test Base.infer_return_type() do
        Val(concrete_eval_eligible_if_false(42., 5, false) == 5sin(42.))
    end == Val
end # if

end # module test_corecompiler_concrete_evaluate
