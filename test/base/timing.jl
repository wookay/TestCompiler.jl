module test_base_timing

# see also TestCompiler/test/corecompiler/timing.jl

# from julia/base/timing.jl

using Test
using Base: @allocated, @allocations, gc_bytes

# function _gen_allocation_measurer(ex, fname::Symbol)  fname === :allocated
function f_allocated(f, a)
Base.Experimental.@force_compile
b0 = Ref{Int64}(0)
b1 = Ref{Int64}(0)
gc_bytes(b0)
f(a)
gc_bytes(b1)
b1[] - b0[]
end

# function _gen_allocation_measurer(ex, fname::Symbol)  fname === :allocations
function f_allocations(f, a)
Base.Experimental.@force_compile
b1 = Ref{Int64}(0)
stats = Base.gc_num()
f(a)
diff = Base.GC_Diff(Base.gc_num(), stats)
gc_bytes(b1)
Base.gc_alloc_count(diff)
end

l = lazy"item $(1)"
@test length(l.parts) == 2
String(l)

if VERSION >= v"1.14.0-DEV.3221" # julia commit 07e2c78d9b
@test f_allocated(  String, lazy"item $(1)"  ) <= 192
@test  @allocated(  String( lazy"item $(1)" )) <= 256
@test f_allocations(String, lazy"item $(1)"  ) <= 5
@test  @allocations(String( lazy"item $(1)" )) <= 7
end

end # module test_base_timing
