module EffectBits # TestCompiler

export c, e, n, t, s, m, u, o, r
export EffectLetter, EffectSuffix, EffectsArgumentError
export effect_bits, detect

import Base: +, !, ~, nameof
using Core: Compiler
import .Compiler: Effects
using  .Compiler: ALWAYS_TRUE, ALWAYS_FALSE,
                  CONSISTENT_IF_NOTRETURNED, CONSISTENT_IF_INACCESSIBLEMEMONLY
using LogicalOperators: AND, OR

include("effect_letters.jl")
include("effect_bits.jl")
include("detect.jl")
include("show.jl")

end # module TestCompiler.EffectBits
