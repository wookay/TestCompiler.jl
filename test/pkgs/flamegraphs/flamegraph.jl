module test_pkgs_flamegraphs_flamegraph

using Test
using Profile
using FlameGraphs

# from FlameGraphs.jl/test/runtests.jl
backtraces1 = UInt64[   4, 3, 2, 1,   # order: callees then caller
                     0, 6, 5, 1,
                     0, 8, 7,
                     0, 4, 3, 2, 1,
                     0]
dummy_thread = 1
dummy_task = UInt(0xf0f0f0f0)
backtraces2 = Profile.add_fake_meta(backtraces1, threadid = dummy_thread, taskid = dummy_task)
@test backtraces1 != backtraces2
@test flamegraph(backtraces2) isa FlameGraphs.LeftChildRightSiblingTrees.Node{FlameGraphs.NodeData}

end # module test_pkgs_flamegraphs_flamegraph
