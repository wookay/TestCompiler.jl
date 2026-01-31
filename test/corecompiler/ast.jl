module test_corecompiler_ast

using Test
using Core: Compiler as CC

# isa_ast_node from julia/base/expr.jl
using .CC: NewvarNode, CodeInfo, LineNumberNode, GotoNode, GotoIfNot, EnterNode, ReturnNode,
           SSAValue, SlotNumber, Argument, QuoteNode, GlobalRef, Symbol, PiNode, PhiNode,
           PhiCNode, UpsilonNode, Expr

# from julia/test/show.jl
# Tests for printing Core.Compiler internal objects
@test repr(SSAValue(23)) == ":(%23)"
@test repr(SSAValue(-2)) == ":(%-2)"
@test repr(ReturnNode(23)) == ":(return 23)"
@test repr(ReturnNode()) == ":(unreachable)"
@test repr(GotoIfNot(true, 4)) == ":(goto %4 if not true)"
@test repr(PhiNode(Int32[2, 3], Any[1, SlotNumber(3)])) == ":(φ (%2 => 1, %3 => _3))"
@test repr(PhiCNode(Any[1, SlotNumber(3)])) == ":(φᶜ (1, _3))"
@test repr(UpsilonNode(SlotNumber(3))) == ":(ϒ (_3))"
@test sprint(Base.show_unquoted, Argument(23)) == "_23"
@test sprint(Base.show_unquoted, Argument(-2)) == "_-2"

# from julia/base/expr.jl
if VERSION >= v"1.13.0-DEV.763"
Base.isa_ast_node
Base.is_self_quoting
end

φ = PhiNode()
@test φ.edges == Int32[]
@test φ.values == Any[]
@test φ == PhiNode(Int32[], Any[])

φᶜ = PhiCNode([])
@test isempty(φᶜ.values)

ϒ = UpsilonNode()
@test hasfield(typeof(ϒ), :val)
@test !isdefined(ϒ, :val)


# ExprNode from julia/base/show.jl
using .CC: Expr, QuoteNode, SlotNumber, LineNumberNode, SSAValue,
           GotoNode, GotoIfNot, GlobalRef, PhiNode, PhiCNode, UpsilonNode,
           ReturnNode

end # module test_corecompiler_ast
