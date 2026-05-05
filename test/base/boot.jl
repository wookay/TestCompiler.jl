module test_base_boot

using Test

using Base: Const, PartialStruct, InterConditional, InterMustAlias
using Core: PartialOpaque

# from julia/base/boot.jl

#=
# inference lattice element types (moved from jltypes.c)
struct Const
    val
    Const(@nospecialize(v)) = new(v)
end

struct PartialStruct
    typ
    undefs::Array{Union{Nothing,Bool}, 1}
    fields::Array{Any, 1}
    # N.B. The constructor for this struct is intentionally not defined here.
    # It is defined in coreir.jl along with some validation logic.
    global _PartialStruct
    _PartialStruct(@nospecialize(typ), undef::Array{Union{Nothing,Bool}, 1}, fields::Array{Any, 1}) = new(typ, undef, fields)
end

struct InterConditional
    slot::Int
    thentype
    elsetype
    InterConditional(slot::Int, @nospecialize(thentype), @nospecialize(elsetype)) = new(slot, thentype, elsetype)
end

struct InterMustAlias
    slot::Int
    vartyp::Any
    fldidx::Int
    fldtyp::Any
    InterMustAlias(slot::Int, @nospecialize(vartyp), fldidx::Int, @nospecialize(fldtyp)) = new(slot, vartyp, fldidx, fldtyp)
end

struct PartialOpaque
    typ::Type
    env
    parent::MethodInstance
    source
    PartialOpaque(@nospecialize(typ::Type), @nospecialize(env), parent::MethodInstance, source) = new(typ, env, parent, source)
end
=#

end # module test_base_boot
