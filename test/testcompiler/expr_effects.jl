module test_testcompiler_expr_effects

using Test
using TestCompiler.EffectBits # c e n t s m u o r
using LogicalOperators: AND, OR

expr = quote
is_consistent(effects::Effects)          = effects.consistent === ALWAYS_TRUE
end

@test expr isa Expr
AND(+c)


# julia/Compiler/src/effects.jl
quote
is_consistent(effects::Effects)          = effects.consistent === ALWAYS_TRUE
is_effect_free(effects::Effects)         = effects.effect_free === ALWAYS_TRUE
is_nothrow(effects::Effects)             = effects.nothrow
is_terminates(effects::Effects)          = effects.terminates
is_notaskstate(effects::Effects)         = effects.notaskstate
is_inaccessiblememonly(effects::Effects) = effects.inaccessiblememonly === ALWAYS_TRUE
is_noub(effects::Effects)                = effects.noub === ALWAYS_TRUE
is_noub_if_noinbounds(effects::Effects)  = effects.noub === NOUB_IF_NOINBOUNDS
is_nonoverlayed(effects::Effects)        = effects.nonoverlayed === ALWAYS_TRUE
is_nortcall(effects::Effects)            = effects.nortcall

# implies `is_notaskstate` & `is_inaccessiblememonly`, but not explicitly checked here
is_foldable(effects::Effects, check_rtcall::Bool=false) =
    is_consistent(effects) &&
    (is_noub(effects) || is_noub_if_noinbounds(effects)) &&
    is_effect_free(effects) &&
    is_terminates(effects) &&
    (!check_rtcall || is_nortcall(effects))

is_foldable_nothrow(effects::Effects, check_rtcall::Bool=false) =
    is_foldable(effects, check_rtcall) &&
    is_nothrow(effects)

# TODO add `is_noub` here?
is_removable_if_unused(effects::Effects) =
    is_effect_free(effects) &&
    is_terminates(effects) &&
    is_nothrow(effects)

is_finalizer_inlineable(effects::Effects) =
    is_nothrow(effects) &&
    is_notaskstate(effects)

is_consistent_if_notreturned(effects::Effects)         = !iszero(effects.consistent & CONSISTENT_IF_NOTRETURNED)
is_consistent_if_inaccessiblememonly(effects::Effects) = !iszero(effects.consistent & CONSISTENT_IF_INACCESSIBLEMEMONLY)

is_effect_free_if_inaccessiblememonly(effects::Effects) = !iszero(effects.effect_free & EFFECT_FREE_IF_INACCESSIBLEMEMONLY)

is_inaccessiblemem_or_argmemonly(effects::Effects) = effects.inaccessiblememonly === INACCESSIBLEMEM_OR_ARGMEMONLY

is_consistent_overlay(effects::Effects) = effects.nonoverlayed === CONSISTENT_OVERLAY
end # quote

end # module test_testcompiler_expr_effects
