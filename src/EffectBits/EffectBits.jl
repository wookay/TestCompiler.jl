module EffectBits # TestCompiler

export c, e, n, t, s, m, u, o, r
export EffectLetter, EffectSuffix, EffectsArgumentError
export effects_field_name
export effects_suffix
export effect_bits
export detect

using Core: Compiler as CC
using .CC: ALWAYS_TRUE,
           ALWAYS_FALSE,
           CONSISTENT_IF_NOTRETURNED,
           CONSISTENT_IF_INACCESSIBLEMEMONLY,
           EFFECT_FREE_IF_INACCESSIBLEMEMONLY,
           EFFECT_FREE_GLOBALLY,
           INACCESSIBLEMEM_OR_ARGMEMONLY,
           NOUB_IF_NOINBOUNDS,
           CONSISTENT_OVERLAY
import .CC: Effects
import Base: +, !, ~
using LogicalOperators: AND, OR

include("effect_letters.jl")
include("effect_bits.jl")
include("detect.jl")
include("show.jl")
include("docview.jl")

end # module TestCompiler.EffectBits
