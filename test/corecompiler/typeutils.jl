module test_corecompiler_typeutils

using Test
using Core: Compiler as CC
using .CC: Const

# from julia/Compiler/src/typeutils.jl
#
# lattice utilities
#
# true if a value of this type is known to be exactly (`===`) the type `T`, so it
# is inlineable as the constant `T`. A general `Type{T}` is not: it also matches
# `S == T` with `S !== T` reps, e.g. `Union{U,V} where {U<:T,V<:T}` (#61323).
# Use `Core.TypeEgal{T}` when that exactness is required; `Type{Union{}}` is the# exception, since the bottom object is unique.
CC.isconstType

@test   CC.isconstType(Type{Union{}})

if VERSION >= v"1.14.0-DEV.2603" # julia commit 6604df474a
@test !(CC.isconstType(Type{Const}))
else
@test   CC.isconstType(Type{Const})
end

@test !(CC.isconstType(Const))
@test !(CC.isconstType(1))
@test !(CC.isconstType(Const(1)))

end # module test_corecompiler_typeutils
