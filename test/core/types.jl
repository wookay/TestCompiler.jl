module test_core_types

using Core: Const, InterConditional, PartialStruct
using Core: CodeInfo, CodeInstance, MethodInstance
if VERSION >= v"1.14-DEV"
    using Core: InterMustAlias
end

end # module test_core_types


using Jive
@If VERSION >= v"1.12" module test_core_types_PartialStruct

using Test
using Core: Const, PartialStruct
using Core.Compiler: Compiler as CC

PartialStruct
# from julia/Compiler/test/inference.jl
PT = PartialStruct(CC.fallback_lattice, Tuple{Int64,UInt64}, Any[Const(10), UInt64])
if VERSION >= v"1.14-DEV"
    @test PT.undefs == [false, false]
else
end
@test PT.typ === Tuple{Int64,UInt64}
@test PT.fields == [Const(10), UInt64]

end # module test_core_types_PartialStruct


#=
help?> Core.Const

  struct Const
      val
  end

  The type representing a constant value.


help?> Core.InterConditional

  struct InterConditional
      slot::Int
      thentype
      elsetype
  end

  Similar to Conditional, but conveys inter-procedural constraints imposed on
  call arguments. This is separate from Conditional to catch logic errors: the
  lattice element name is InterConditional while processing a call, then
  Conditional everywhere else.


help?> Core.PartialStruct

  struct PartialStruct
      typ
      undefs::Vector{Union{Nothing,Bool}} # represents whether a given field may be undefined
      fields::Vector{Any} # i-th element describes the lattice element for the i-th defined field
  end

  This extended lattice element is introduced when we have information about
  an object's fields beyond what can be obtained from the object type. E.g. it
  represents a tuple where some elements are known to be constants or a struct
  whose Any-typed field is initialized with value whose type is concrete.

  • typ indicates the type of the object

  • undefs records defined-ness of each field

  • fields holds the lattice elements corresponding to each field of the object

  ...


help?> Core.InterMustAlias

  alias::InterMustAlias

  This lattice element used in a very similar way as InterConditional, but corresponds to MustAlias.


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
