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
