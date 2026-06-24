using Jive
@If VERSION >= v"1.12" module test_corecompiler_domtree

# see also ssair.jl

using Test
using Core: Compiler as CC

using .CC: BBNumber, PreNumber, PostNumber
@test BBNumber === PreNumber === PostNumber === Int
# from julia/Compiler/src/ssair/domtree.jl
#=
# We could make these real structs, but probably not worth the extra
# overhead. Still, give them names for documentary purposes.
const BBNumber = Int
const PreNumber = Int
const PostNumber = Int
=#

using .CC: IRCode, BasicBlock, StmtRange

function Base.:(==)(a::T, b::T)::Bool where T <: BasicBlock
    a.stmts == b.stmts &&
    a.preds == b.preds &&
    a.succs == b.succs
end

ir = IRCode()

for (bb::BBNumber, idx::Int) in CC.bbidxiter(ir)
    @test bb == 1
    @test idx == 1
end

for (idx::Int, block::BasicBlock) in pairs(ir.cfg.blocks)
    @test idx == 1
    @test block == BasicBlock(StmtRange(1:1))
end


using .CC: DomTreeNode

function Base.:(==)(a::T, b::T)::Bool where T <: DomTreeNode
    a.level == b.level &&
    a.children == b.children
end

@test DomTreeNode() == DomTreeNode(1, BBNumber[])


if VERSION >= v"1.14.0-DEV.2347" # julia commit cb6f0fb506

using .CC: DomTreeCache
cache = DomTreeCache()
@test cache.worklist isa Vector{Tuple{Int, Int}}

end # if


#=
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

"Iterable data structure that walks though all dominated blocks"
struct DominatedBlocks
    domtree::DomTree
    worklist::Vector{BBNumber}
end

"Represents a Basic Block, in the DomTree"
struct DomTreeNode
    # How deep we are in the DomTree
    level::Int
    # The BB indices in the CFG for all Basic Blocks we immediately dominate
    children::Vector{BBNumber}
end

# v"1.14.0-DEV.2347"  julia commit cb6f0fb506
struct DomTreeCache
    ancestors::Vector{PreNumber}
    idoms_pre::Vector{PreNumber}
    worklist::Vector{Tuple{Int, Int}}
end

function update_level!(nodes::Vector{DomTreeNode}, node::BBNumber, level::Int,
                       worklist::Vector{Tuple{BBNumber, Int}})

function snca_compress_worklist!(
        state::Vector{SNCAData}, ancestors::Vector{PreNumber},
        v::PreNumber, last_linked::PreNumber,
        worklist::Vector{Tuple{PreNumber, PreNumber}})
=#

end # module test_corecompiler_domtree
