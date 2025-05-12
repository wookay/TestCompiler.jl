# module TestCompiler.EffectBits

### effect_bits
effect_bits(::typeof(CC.is_consistent))::AND{EffectLetter}          = AND(+c                           )
effect_bits(::typeof(CC.is_effect_free))::AND{EffectLetter}         = AND(   +e                        )
effect_bits(::typeof(CC.is_nothrow))::AND{EffectLetter}             = AND(      +n                     )
effect_bits(::typeof(CC.is_terminates))::AND{EffectLetter}          = AND(         +t                  )
effect_bits(::typeof(CC.is_notaskstate))::AND{EffectLetter}         = AND(            +s               )
effect_bits(::typeof(CC.is_inaccessiblememonly))::AND{EffectLetter} = AND(               +m            )
effect_bits(::typeof(CC.is_noub))::AND{EffectLetter}                = AND(                  +u         )
effect_bits(::typeof(CC.is_noub_if_noinbounds))::AND{EffectLetter}  = AND(                     ~u      ) # ?u .noub == NOUB_IF_NOINBOUNDS
effect_bits(::typeof(CC.is_nonoverlayed))::AND{EffectLetter}        = AND(                        +o   )
effect_bits(::typeof(CC.is_nortcall))::AND{EffectLetter}            = AND(                           +r)

function effect_bits(::typeof(CC.is_foldable), check_rtcall::Bool=false)::AND
    AND(+c, OR(+u, ~u), +e, +t, OR(!check_rtcall, +r))
end
function effect_bits(::typeof(CC.is_foldable_nothrow), check_rtcall::Bool=false)::AND
    AND(effect_bits(Compiler.is_foldable, check_rtcall)..., +n)
end
function effect_bits(::typeof(CC.is_removable_if_unused))::AND{EffectLetter}
    AND(+e, +t, +n)
end
function effect_bits(::typeof(CC.is_finalizer_inlineable))::AND{EffectLetter}
    AND(+n, +s)
end
function effect_bits(::typeof(CC.is_consistent_if_notreturned))::AND{EffectLetter}
    AND(EffectLetter(CONSISTENT_IF_NOTRETURNED, 'c'))
end
function effect_bits(::typeof(CC.is_consistent_if_inaccessiblememonly))::AND{EffectLetter}
    AND(EffectLetter(CONSISTENT_IF_INACCESSIBLEMEMONLY, 'c'))
end
function effect_bits(::typeof(CC.is_effect_free_if_inaccessiblememonly))::AND{EffectLetter}
    AND(~e) # ?e .effect_free == EFFECT_FREE_IF_INACCESSIBLEMEMONLY
end
function effect_bits(::typeof(CC.is_inaccessiblemem_or_argmemonly))::AND{EffectLetter}
    AND(~m) # ?m .inaccessiblememonly == INACCESSIBLEMEM_OR_ARGMEMONLY
end
function effect_bits(::typeof(CC.is_consistent_overlay))::AND{EffectLetter}
    AND(~o) # ?o .nonoverlayed == CONSISTENT_OVERLAY
end

# module TestCompiler.EffectBits
