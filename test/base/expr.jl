module test_base_expr

using Test
using InteractiveUtils: @code_typed

# julia/base/expr.jl
using Base: is_short_function_def, is_function_def

@test is_short_function_def(:( f() = nothing ))
@test is_function_def(:( function f() end ))

@test :( (:a,) ) == Expr(:tuple, QuoteNode(:a))

# help?> Base.@nospecializeinfer
                        g1(              A::AbstractArray ) = A[1]
                        g2(@nospecialize(A::AbstractArray)) = A[1]
Base.@nospecializeinfer g3(              A::AbstractArray ) = A[1]
Base.@nospecializeinfer g4(@nospecialize(A::AbstractArray)) = A[1]

(c1, t1) = @code_typed g1([1.0])
(c2, t2) = @code_typed g2([1.0])
(c3, t3) = @code_typed g3([1.0])
(c4, t4) = @code_typed g4([1.0])

@test c1.code == c2.code == c3.code
if VERSION >= v"1.12"
@test sprint(show, c4) == """
    CodeInfo(
    1 ─ %1 =   dynamic Base.getindex(A, 1)::Any
    └──      return %1
    )"""
elseif VERSION >= v"1.11"
@test sprint(show, c4) == """
    CodeInfo(
    1 ─ %1 = Base.getindex(A, 1)::Any
    └──      return %1
    )"""
end
@test t1 === t2 === t3 === Float64
@test t4 === Any

end # module test_base_expr
