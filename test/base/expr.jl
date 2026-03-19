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

code_coverage = Base.JLOptions().code_coverage != 0
if VERSION >= v"1.12"
if code_coverage
    @test sprint(show, c4) == """
    CodeInfo(
    1 ─      $(Expr(:code_coverage_effect))::Nothing
    │   %2 =   dynamic Base.getindex(A, 1)::Any
    └──      return %2
    )"""
else
    @test sprint(show, c4) == """
    CodeInfo(
    1 ─ %1 =   dynamic Base.getindex(A, 1)::Any
    └──      return %1
    )"""
end # if code_coverage
elseif VERSION >= v"1.11"
if code_coverage
    @test sprint(show, c4) == """
    CodeInfo(
    1 ─      $(Expr(:code_coverage_effect))::Nothing
    │   %2 = Base.getindex(A, 1)::Any
    └──      return %2
    )"""
else
    @test sprint(show, c4) == """
    CodeInfo(
    1 ─ %1 = Base.getindex(A, 1)::Any
    └──      return %1
    )"""
end # if code_coverage
end

@test t1 === t2 === t3 === Float64
@test t4 === Any


Base.@nospecialize # from julia/base/boot.jl
                   #      julia/base/essentials.jl

(c5, t5) = @code_typed @nospecialize(A)
if VERSION >= v"1.14.0-DEV.1918" # julia commit 78a0dc1151
    @test sprint(show, c5) == """
    CodeInfo(
    1 ─      nothing::Nothing
    │        nothing::Nothing
    │   %3 =   builtin Core.getfield(vars, 1)::Symbol
    │   %4 =   builtin Core._expr(:meta, :nospecialize, %3)::Expr
    │   %5 =   builtin Core._expr(:escape, %4)::Expr
    └──      return %5
    )"""
elseif VERSION >= v"1.12"
    @test sprint(show, c5) == """
    CodeInfo(
    1 ─      nothing::Nothing
    │        nothing::Nothing
    │   %3 =   builtin Core.getfield(vars, 1)::Symbol
    │   %4 =   builtin Core._expr(:meta, :nospecialize, %3)::Expr
    └──      return %4
    )"""
elseif VERSION >= v"1.11"
    if !code_coverage
    @test sprint(show, c5) == """
    CodeInfo(
    1 ─      nothing::Nothing
    │        nothing::Nothing
    │   %3 = Core.getfield(vars, 1)::Symbol
    │   %4 = Core._expr(:meta, :nospecialize, %3)::Expr
    └──      return %4
    )"""
    end # if !code_coverage
end # if
@test t5 === Expr

end # module test_base_expr
