module test_corecompiler_core_kwcall

using Test

function g(f, args...; kwargs...)
    kwargs = merge((;), kwargs)
    Core.kwcall(kwargs, f, args...)
end

f(args...; kwargs...) = (args = args, kwargs = kwargs)

@test g(f)           == (args = (),    kwargs = pairs((;)))
@test g(f   ; b = 2) == (args = (),    kwargs = pairs((; b = 2)))
@test g(f, 1; b = 2) == (args = (1, ), kwargs = pairs((; b = 2)))

end # module test_corecompiler_core_kwcall


module test_corecompiler_core_finalizers

using Test

# from julia/test/core.jl

let A = [9], x = 0
    @test ismutable(A)
    finalizer(_->(x+=1), A)
    @test x == 0
    finalize(A)
    @test x == 1
end

let A = [9], x = 0
    finalizer(_->(x+=1), A)

    A = []
    finalize(A)
    @test x == 0
end

@test !isdefined(@__MODULE__, :A)

end # module test_corecompiler_core_finalizers


#=
help?> Core.CodeInfo
  mutable struct Core.CodeInfo
  ≡≡≡≡≡≡
  code                                  :: Vector{Any}
  codelocs                              :: Vector{Int32}
  ssavaluetypes                         :: Any
  ssaflags                              :: Vector{UInt32}
  method_for_inference_limit_heuristics :: Any
  linetable                             :: Any
  slotnames                             :: Vector{Symbol}
  slotflags                             :: Vector{UInt8}
  slottypes                             :: Any
  rettype                               :: Any
  parent                                :: Any
  edges                                 :: Any
  min_world                             :: UInt64
  max_world                             :: UInt64
  inferred                              :: Bool
  propagate_inbounds                    :: Bool
  has_fcall                             :: Bool
  nospecializeinfer                     :: Bool
  inlining                              :: UInt8
  constprop                             :: UInt8
  purity                                :: UInt16
  inlining_cost                         :: UInt16

help?> Core.CodeInstance
  mutable struct Core.CodeInstance
  ≡≡≡≡≡≡
  def              :: Core.MethodInstance
  owner            :: Any
  next             :: Core.CodeInstance
  min_world        :: UInt64
  max_world        :: UInt64
  rettype          :: Any
  exctype          :: Any
  rettype_const    :: Any
  inferred         :: Any
  ipo_purity_bits  :: UInt32
  purity_bits      :: UInt32
  analysis_results :: Any
  specsigflags     :: Bool
  precompile       :: Bool
  relocatability   :: UInt8
  invoke           :: Ptr{Nothing}
  specptr          :: Ptr{Nothing}

help?> Core.MethodInstance
  mutable struct Core.MethodInstance
  ≡≡≡≡≡≡
  def             :: Union{Method, Module}
  specTypes       :: Any
  sparam_vals     :: Core.SimpleVector
  uninferred      :: Any
  backedges       :: Vector{Any}
  cache           :: Core.CodeInstance
  inInference     :: Bool
  cache_with_orig :: Bool
  precompiled     :: Bool
=#
