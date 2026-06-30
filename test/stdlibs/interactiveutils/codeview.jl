module test_stdlibs_InteractiveUtils_codeview

using Test
using InteractiveUtils

# from julia/stdlib/InteractiveUtils/src/codeview.jl

code_warntype

f = +
types = (Int, Int)
iob = IOBuffer()
code_warntype(iob, f, types)

if VERSION >= v"1.14-DEV"
@test String(take!(iob)) == """
MethodInstance for +(::Int64, ::Int64)
  from +(x::Int64, y::Int64) @ Base essentials.jl:1226
Arguments
  #self#::Core.Const(+)
  x::Int64
  y::Int64
Body::Int64
1 ─ %1 = Base.add_int::Core.Const(Core.Intrinsics.add_int)
│   %2 = (%1)(x, y)::Int64
└──      return %2

"""

elseif VERSION >= v"1.11"
@test String(take!(iob)) == """
MethodInstance for +(::Int64, ::Int64)
  from +(x::T, y::T) where T<:Union{Int128, Int16, Int32, Int64, Int8, UInt128, UInt16, UInt32, UInt64, UInt8} @ Base int.jl:87
Static Parameters
  T = Int64
Arguments
  #self#::Core.Const(+)
  x::Int64
  y::Int64
Body::Int64
1 ─ %1 = Base.add_int::Core.Const(Core.Intrinsics.add_int)
│   %2 = (%1)(x, y)::Int64
└──      return %2

"""
end # if

end # module test_stdlibs_InteractiveUtils_codeview
