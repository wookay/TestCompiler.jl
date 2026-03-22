module test_core_types

using Core: Const, InterConditional, PartialStruct, CodeInfo, CodeInstance, MethodInstance

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


module test_core_types_InterConditional

using Test
using Core: InterConditional

cond = InterConditional(1, Int, Union{})
@test cond.slot == 1
@test cond.thentype === Int
@test cond.elsetype === Union{}

end # module test_core_types_InterConditional


@If VERSION >= v"1.14-DEV" module test_core_types_InterMustAlias

using Test
using Core: Const, InterMustAlias
using Core.Compiler: Compiler as CC
using .CC: Conditional, MustAlias, ⊑

# from julia/Compiler/test/inference.jl
cnd = Conditional(#= slot =# 0, #= ssadef =# 0, Const(Union{}), Const(Union{}))
@test cnd.slot == 0
@test cnd.ssadef == 0
@test cnd.thentype == Const(Union{})
@test cnd.elsetype == Const(Union{})
@test cnd.isdefined === false

struct AliasableField{T}
    f::T
end

must_alias = MustAlias(2, 0, AliasableField{Any}, 1, Int)
@test must_alias.slot == 2
@test must_alias.ssadef == 0
@test must_alias.vartyp === AliasableField{Any}
@test must_alias.fldidx == 1
@test must_alias.fldtyp === Int
@test must_alias ⊑ Int
@test ⊑(CC.fallback_lattice, must_alias, Int)
# from julia/Compiler/src/abstractlattice.jl
# @nospecializeinfer @nospecialize(a) ⊑ @nospecialize(b) = ⊑(fallback_lattice, a, b)

inter_must_alias = InterMustAlias(2, Some{Any}, 1, Int)
@test inter_must_alias.slot == 2
@test inter_must_alias.vartyp === Some{Any}
@test inter_must_alias.fldidx == 1
@test inter_must_alias.fldtyp === Int

end # module test_core_types_InterMustAlias


#=
help?> Core.Const

  struct Const
      val
  end

  The type representing a constant value.


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


help?> Core.Compiler.Conditional

  cnd::Conditional

  The type of this value might be Bool. However, to enable a limited amount of back-propagation, we also keep some
  information about how this Bool value was created. In particular, if you branch on this value, then may assume that in
  the true branch, the type of SlotNumber(cnd.slot) will be limited by cnd.thentype and in the false branch, it will be
  limited by cnd.elsetype. Example:

  let cond = isa(x::Union{Int, Float}, Int)::Conditional(x, _, Int, Float)
      if cond
         # May assume x is `Int` now
      else
         # May assume x is `Float` now
      end
  end


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


help?> Core.Compiler.:⊑

  ⊑(𝕃::AbstractLattice, a, b)

  Compute the lattice ordering (i.e. less-than-or-equal) relationship between
  lattice elements a and b over the lattice 𝕃. If 𝕃 is JLTypeLattice, this is
  equivalent to subtyping.


help?> Core.Compiler.MustAlias

  alias::MustAlias

  This lattice element wraps a reference to object field while recoding the identity of the parent object. It allows
  certain constraints that can be imposed on the object field type by built-in functions like isa and === to be
  propagated to another reference to the same object field. One important note is that this lattice element assumes the
  invariant that the field of wrapped slot object never changes until the slot object is re-assigned. This means, the
  wrapped object field should be constant as inference currently doesn't track any memory effects on per-object basis.
  Particularly maybe_const_fldidx takes the lift to check if a given lattice element is eligible to be wrapped by
  MustAlias. Example:

  let alias = getfield(x::Some{Union{Nothing,String}}, :value)::MustAlias(x, Some{Union{Nothing,String}}, 1, Union{Nothing,String})
      if alias === nothing
          # May assume `getfield(x, :value)` is `nothing` now
      else
          # May assume `getfield(x, :value)` is `::String` now
      end
  end

  N.B. currently this lattice element is only used in abstractinterpret, not in optimization


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
