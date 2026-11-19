module test_base_meta

using Test

@test Expr(:call, :+, 1, 2) ==
      Meta.parse("1 + 2") ==
      :(1 + 2)

@test Meta.isexpr(:(1 + 2), :call)
@test Meta.isexpr(quote end, :block)
@test Meta.isexpr(:(), :tuple)
@test Meta.isexpr(:(function () end), :function)

if VERSION >= v"1.13.0-DEV.980"
Meta.reescape
end

@test_nowarn                             1e308
@test_nowarn                 Meta.parse("1e308")
@test_throws Meta.ParseError Meta.parse("1e309")

expr = Meta.lower(@__MODULE__, :(1 + 2))
@test Meta.isexpr(expr, :thunk)

@test Core.eval(@__MODULE__, expr) ==
      ccall(:jl_toplevel_eval_in, Any, (Any, Any), @__MODULE__, expr) ==
      3

if VERSION >= v"1.15.0-DEV.441" # julia commit f3250b9a37
@test Base.fl_toplevel_eval(@__MODULE__, expr) ==
      ccall(:jl_toplevel_eval, Any, (Any, Any), @__MODULE__, expr) ==
      3
end

end # module test_base_meta
