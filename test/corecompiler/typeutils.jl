module test_corecompiler_typeutils

# see also base/runtime_internals.jl

using Test
using Core: Compiler as CC
using .CC: Const

# from julia/Compiler/src/typeutils.jl
#
# lattice utilities

CC.isconstType
# true if a value of this type is known to be exactly (`===`) the type `T`, so it
# is inlineable as the constant `T`. A general `Type{T}` is not: it also matches
# `S == T` with `S !== T` reps, e.g. `Union{U,V} where {U<:T,V<:T}` (#61323).
# Use `Core.TypeEgal{T}` when that exactness is required; `Type{Union{}}` is the# exception, since the bottom object is unique.
#
# isconstType(@nospecialize t) = isTypeEgal(t) || (isTypeEq(t) && type_parameter(t) === Union{})

CC.isTypeDataType
# isTypeDataType(@nospecialize t)::Bool
#
# For a type `t` test whether ∀S s.t. `isa(S, rewrap_unionall(Type{t}, ...))`,
# we have `isa(S, DataType)`. In particular, if a statement is typed as `Type{t}`
# (potentially wrapped in some `UnionAll`), then we are guaranteed that this statement
# will be a `DataType` at runtime (and not e.g. a `Union` or `UnionAll` typeequal to it).
#=
function isTypeDataType(@nospecialize t)
    isType(t) && return false
    isa(t, DataType) || return false
    # Could be Union{} at runtime
    t === Core.TypeofBottom && return false
    # Return true if `t` is not covariant
    return t.name !== Tuple.name
end
=#

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
