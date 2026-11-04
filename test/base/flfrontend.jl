using Jive
@If VERSION >= v"1.15.0-DEV.441" module test_base_flfrontend
# julia commit f3250b9a37

using Test

Base.fl_lower
Base.fl_toplevel_eval

#=
julia> (first ∘ Base.fl_lower)(:(1 + 2), @__MODULE__)
:($(Expr(:thunk, CodeInfo(
1 ─ %1 = Main.:+
│   %2 =   dynamic (%1)(1, 2)
└──      return %2
))))
=#

@test Base.fl_toplevel_eval(@__MODULE__, :(1 + 2)) == 3

end # module test_base_flfrontend
