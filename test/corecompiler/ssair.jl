using Jive
@If VERSION >= v"1.12" module test_corecompiler_ssair

# Static Single Assignment (SSA)
# Intermediate Representation (IR)

using Test
using Core: Compiler as CC

# isa_ast_node from julia/base/expr.jl
using .CC: CodeInfo, SSAValue, SlotNumber, Argument, GlobalRef, GotoIfNot,
           NewvarNode, LineNumberNode, GotoNode, EnterNode, ReturnNode,
           QuoteNode, PiNode, PhiNode, PhiCNode, UpsilonNode

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

# from julia/Compiler/test/ssair.jl
ssa_value = SSAValue(6)
@test ssa_value.id == 6

pi_node = PiNode(ssa_value, GotoNode)
@test pi_node.val == ssa_value
@test pi_node.typ == GotoNode

enter_node = EnterNode(11)
@test enter_node.catch_dest == 11
@test !isdefined(enter_node, :scope)

argument = Argument(1)
@test argument.n == 1


# from julia/Compiler/test/ssair.jl
using .CC: IRCode, CFG, DFS, BasicBlock, StmtRange

ir = IRCode()

blocks = [BasicBlock(1:1, Int[], Int[])]
index = [1]
cfg = CFG(blocks, index)
# CFG with 1 blocks:
#   bb 1 (stmt 1)
@test only(ir.cfg.blocks).stmts == only(cfg.blocks).stmts == StmtRange(1, 1)
@test only(ir.cfg.blocks).preds == only(cfg.blocks).preds == Int[]
@test only(ir.cfg.blocks).succs == only(cfg.blocks).succs == Int[]

dfs = DFS(blocks, false)
# Compiler.DFSTree([1], [1], [1], [1], [0], Tuple{Int64, Int64, Bool}[])
@test dfs.to_pre == [1]
@test dfs.from_pre == [1]
@test dfs.to_post == [1]
@test dfs.from_post == [1]
@test dfs.to_parent_pre == [0]


#=
# from julia/Compiler/src/ssair/basicblock.jl
struct BasicBlock
    stmts::StmtRange
    preds::Vector{Int}
    succs::Vector{Int}
end


# from julia/Compiler/src/ssair/ir.jl
IRCode()

struct CFG
    blocks::Vector{BasicBlock}
    index::Vector{Int} # map from instruction => basic-block number
end


# from julia/Compiler/src/ssair/domtree.jl
struct DFSTree
    # These map between BB number and pre- or postorder numbers
    to_pre::Vector{PreNumber}
    from_pre::Vector{BBNumber}
    to_post::Vector{PostNumber}
    from_post::Vector{BBNumber}

    # Records parent relationships in the DFS tree
    # (preorder number -> preorder number)
    # Storing it this way saves a few lookups in the snca_compress! algorithm
    to_parent_pre::Vector{PreNumber}

    _worklist::Vector{Tuple{BBNumber, PreNumber, Bool}}
end
=#

end # module test_corecompiler_ssair
