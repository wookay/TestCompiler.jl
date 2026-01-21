module test_base_expr

using Test

# julia/base/expr.jl
using Base: is_short_function_def, is_function_def

@test is_short_function_def(:( f() = nothing ))
@test is_function_def(:( function f() end ))

@test :( (:a,) ) == Expr(:tuple, QuoteNode(:a))

end # module test_base_expr
