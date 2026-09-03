module test_base_atomics

using Test
using Base: @atomic

# from julia/doc/src/manual/multi-threading.md
#      julia/base/atomics.jl
#      julia/base/expr.jl

# Memory ordering
# @atomic order::Symbol
          :monotonic
          :acquire
          :release
          :acquire_release
          :sequentially_consistent

Core.setfield!
Core.swapfield!
Core.modifyfield!
Core.replacefield!
Core.Intrinsics.atomic_fence

end # module test_base_atomics
