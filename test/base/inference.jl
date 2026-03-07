using Jive
# julia commit 44c835795b
@If VERSION >= v"1.14.0-DEV.1826" module test_base_inference

using Test

# from julia/Compiler/test/inference.jl
function f(x::Any)
    y = x
    if x isa Int
        return sin(y)
    end
    error("x is not Int")
end
@test Base.infer_return_type(f, (Any,)) == Float64
@test Base.infer_return_type(f, (Int,)) == Float64
@test Base.infer_return_type(f, (String,)) == Union{}

end # module test_base_inference
