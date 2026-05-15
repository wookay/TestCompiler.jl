module test_base_coreio

using Test

if VERSION >= v"1.14.0-DEV.2189" # julia commit dbb9a28a45
    @test typeof(print).name.max_methods == UInt8(1)
else
    @test typeof(print).name.max_methods == 0x00
end


#=
  mutable struct Core.TypeName

  Fields
  ≡≡≡≡≡≡

  name                :: Symbol
  module              :: Module
  singletonname       :: Symbol
  names               :: Core.SimpleVector
  atomicfields        :: Ptr{Nothing}
  constfields         :: Ptr{Nothing}
  wrapper             :: Type
  Typeofwrapper       :: Type
  cache               :: Core.SimpleVector
  linearcache         :: Core.MethodCache
  partial             :: Any
  hash                :: Int64
  max_args            :: Int32
  n_uninitialized     :: Int32
  flags               :: UInt8
  cache_entry_count   :: UInt8
  max_methods         :: UInt8
  constprop_heuristic :: UInt8
=#

end # module test_base_coreio
