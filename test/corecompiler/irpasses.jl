using Jive
# julia commit 98cff0f2fa
@If VERSION >= v"1.14.0-DEV.1791" module test_corecompiler_irpasses

using Test
using FemtoCompiler: code_typed1
using Core: Compiler as CC
using .CC: VarState, CodeInfo, IRCode, IncrementalCompact, singleton_type, isexpr

# from julia/Compiler/test/irutils.jl
argextype(@nospecialize args...) = CC.argextype(args..., VarState[])

isnew(@nospecialize x) = isexpr(x, :new)

# check if `x` is a dynamic call of a given function
iscall(y) = @nospecialize(x) -> iscall(y, x)
function iscall((src, f)::Tuple{IR,Base.Callable}, @nospecialize(x)) where IR<:Union{CodeInfo,IRCode,IncrementalCompact}
    return iscall(x) do @nospecialize x
        singleton_type(argextype(x, src)) === f
    end
end
function iscall(pred::Base.Callable, @nospecialize(x))
    if isexpr(x, :(=))
        x = x.args[2]
    end
    return isexpr(x, :call) && pred(x.args[1])
end


# from julia/Compiler/test/irpasses.jl
struct LiftCachePoint
    x::Float64
    y::Float64
end
let src = code_typed1((Bool,)) do cond
        p = cond ? LiftCachePoint(1.0, 2.0) : LiftCachePoint(3.0, 4.0)
        return abs(p.x) + p.x * 2.0
    end
    @test count(isnew, src.code) == 0
    @test !any(iscall((src, getfield)), src.code)
    # the lifting cache should deduplicate: only 1 phi for `p.x`, not 2
    @test count(x -> isa(x, Core.PhiNode), src.code) == 1
end

end # module test_corecompiler_irpasses
