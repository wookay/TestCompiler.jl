module test_corecompiler_ssair

using Test
using Core: Compiler as CC
using .CC: StmtRange, BasicBlock
using .CC: CFG, DFS, DFSTree


#### from julia/Compiler/src/ssair/basicblock.jl
# Like UnitRange{Int}, but can handle the `last` field, being temporarily
# < first (this can happen during compacting)
# struct StmtRange <: AbstractUnitRange{Int}
#     start::Int
#     stop::Int
# end
#
# struct BasicBlock
#     stmts :: Core.Compiler.StmtRange
#     preds :: Vector{Int64}
#     succs :: Vector{Int64}

# control-flow graph
#### from julia/Compiler/src/ssair/ir.jl
# struct CFG
#     blocks::Vector{BasicBlock}
#     index::Vector{Int} # map from instruction => basic-block number
#                        # TODO: make this O(1) instead of O(log(n_blocks))?

# depth-first
#### from julia/Compiler/src/ssair/domtree.jl
# struct DFSTree
#     # These map between BB number and pre- or postorder numbers
#     to_pre::Vector{PreNumber}
#     from_pre::Vector{BBNumber}
#     to_post::Vector{PostNumber}
#     from_post::Vector{BBNumber}
#
#     # Records parent relationships in the DFS tree
#     # (preorder number -> preorder number)
#     # Storing it this way saves a few lookups in the snca_compress! algorithm
#     to_parent_pre::Vector{PreNumber}
#
#     _worklist::Vector{Tuple{BBNumber, PreNumber, Bool}}


#### from julia/Compiler/test/ssair.jl

cfg = CFG(BasicBlock[], Int[])
@test cfg.blocks == BasicBlock[]
@test cfg.index  == Int[]
@test_throws BoundsError DFS(cfg.blocks)

make_bb(preds, succs)::BasicBlock = BasicBlock(StmtRange(0, 0), preds, succs)

cfg = CFG(BasicBlock[
    make_bb([]     , [2, 3]),
    make_bb([1]    , [4, 5]),
    make_bb([1]    , [4]   ),
    make_bb([2, 3] , [5]   ),
    make_bb([2, 4] , []    ),
], Int[])
@test cfg.blocks[1].stmts == StmtRange(0, 0)
@test cfg.blocks[1].preds == Int[]
@test cfg.blocks[1].succs == Int[2, 3]
@test cfg.index == Int[]

dfs = DFS(cfg.blocks)
@test dfs.to_pre        == [1, 5, 2, 3, 4]
@test dfs.from_pre      == [1, 3, 4, 5, 2]
@test dfs.to_post       == [5, 4, 3, 2, 1]
@test dfs.from_post     == [5, 4, 3, 2, 1]
@test dfs.to_parent_pre == [0, 1, 2, 3, 1]
@test dfs._worklist     == Tuple{Int, Int, Bool}[]


# Static single-assignment form
# https://en.wikipedia.org/wiki/Static_single-assignment_form
#
# In compiler design,
# static single assignment form (often abbreviated as SSA form or simply SSA) is
# a type of intermediate representation (IR) where each variable is assigned exactly once.

# Dominator (graph theory)
# https://en.wikipedia.org/wiki/Dominator_(graph_theory)
#
# In computer science,
# a node d of a control-flow graph dominates a node n if every path from the entry node to n must go through d.
# Notationally, this is written as d dom n (or sometimes d ≫ n).
# By definition, every node dominates itself.
#
# There are a number of related concepts:
#   - A node d strictly dominates a node n if d dominates n and d does not equal n.
#   - The immediate dominator or idom of a node n is the unique node that strictly dominates n
#     but does not strictly dominate any other node that strictly dominates n.
#     Every node reachable from the entry node has an immediate dominator (except the entry node).
#   - The dominance frontier of a node d is the set of all nodes ni such that d dominates an immediate predecessor of ni,
#     but d does not strictly dominate ni. It is the set of nodes where d's dominance stops.
#   - A dominator tree is a tree where each node's children are those nodes it immediately dominates.
#     The start node is the root of the tree.

end # module test_corecompiler_ssair
