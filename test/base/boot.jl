module test_base_boot

# from julia/base/boot.jl

using Test

Core.BFloat16 # primitive type BFloat16 <: AbstractFloat 16 end
b16 = Core.Intrinsics.fptrunc(Core.BFloat16, 3.14)
@test bitstring(b16)           == "0100000001001001"
@test bitstring(Float16(3.14)) == "0100001001001000"


# lattice element types
using Base: Const, PartialStruct, InterConditional
# Base.InterMustAlias
Core.PartialOpaque

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
