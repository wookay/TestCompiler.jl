module test_base_flfrontend

using Test

Base.fl_lower

#=
julia> (first ∘ Base.fl_lower)(:(1 + 2), @__MODULE__)
:($(Expr(:thunk, CodeInfo(
1 ─ %1 = Main.:+
│   %2 =   dynamic (%1)(1, 2)
└──      return %2
))))
=#

end # module test_base_flfrontend
