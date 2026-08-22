using Jive
@If VERSION >= v"1.14-DEV" module test_base_reflection_infer_effects

# see also test/corecompiler/effects.jl

using Test
using Core: Compiler as CC

# from julia/base/expr.jl
# function compute_assumed_setting(override::EffectsOverride, @nospecialize(setting), val::Bool=true)
# from julia/Compiler/src/typeinfer.jl
# function adjust_effects(ipo_effects::Effects, def::Method)
#
# :consistent            +c
#                        ?c                                       CONSISTENT_IF_NOTRETURNED
#                        ?c                                       CONSISTENT_IF_INACCESSIBLEMEMONLY
# :effect_free              +e
#                           ?e                                    EFFECT_FREE_IF_INACCESSIBLEMEMONLY
# :reset_safe                  +re
#                              ?re                                RESET_SAFE_IF_INACCESSIBLEMEMONLY
# :nothrow                         +n
# :terminates_globally                +t
# :terminates_locally                 +t
# :notaskstate                           +s
# :inaccessiblememonly                     +m
#                                          ?m                     INACCESSIBLEMEM_OR_ARGMEMONLY
# :noub                                        +u
# :noub_if_noinbounds                          ?u                 NOUB_IF_NOINBOUNDS
# :nonoverlayed                                   +o
# :consistent_overlay                             ?o              CONSISTENT_OVERLAY
# :nortcall                                          +r
# :foldable              +c,+e,       +t,      +u,   +r
# :removable                +e,    +n,+t
# :total                 +c,+e,    +n,+t,+s,+m,+u,   +r           :terminates_globally true
#                                                                 :terminates_locally false
#                                                                 :noub_if_noinbounds false
#                                                                 :consistent_overlay false

e = Base.infer_effects(+, Tuple{Int, Int})
@test repr(e) == "(+c,+e,+re,+n,+t,+s,+m,+u,+o,+r)"

# julia/base/reinterpretarray.jl
# @assume_effects :foldable function ispacked(T)
e = Base.infer_effects(         Base.ispacked, Tuple{Any})
code_coverage = Base.JLOptions().code_coverage != 0
if code_coverage    
@test repr(e) == "(+c,!e,!re,!n,+t,+s,!m,+u,+o,+r)" # !e
else
# :foldable        +c,+e,       +t,      +u,   +r
@test repr(e) == "(+c,+e,+re,!n,+t,+s,+m,+u,+o,+r)" # +e
end
@test CC.is_foldable(e)

# julia/base/strings/util.jl
# @assume_effects :removable :foldable function chomp(s::Union{String, SubString{String}})
e = Base.infer_effects(                         chomp,
                                                   Tuple{Union{String, SubString{String}}})
# :removable          +e,    +n,+t
# :foldable        +c,+e,       +t,      +u,   +r
@test repr(e) == "(+c,+e,!re,+n,+t,!s,!m,+u,+o,+r)"
@test CC.is_removable_if_unused(e)
@test CC.is_foldable(e)

end # module test_base_reflection_infer_effects


module test_base_reflection_code_ircode

using Test

@test Base.code_ircode(()) == Any[]

(code, ty) = only(Base.code_ircode(+, (Int, Int)))
T = typeof(code)
M = parentmodule(T) # Compiler
@test code isa M.IRCode
@test ty === Int

end # module test_base_reflection_code_ircode


module test_base_reflection_generator

using Test

# from julia/base/reflection.jl
#      julia/test/reflection.jl

function f(x::Int, y::Int)
    println.(stacktrace())
    x + y
end

@generated function g(x::Int, y::Int)
    println.(stacktrace())
    :(x + y)
end

mf = Base.method_instance(f, (Int, Int))
mg = Base.method_instance(g, (Int, Int))

# from julia/base/runtime_internals.jl
# hasgenerator(m::Method) = isdefined(m, :generator)
@test Base.hasgenerator(mf) === false
@test Base.hasgenerator(mg) === true

#=
f(1, 2)
f(x::Int64, y::Int64) at reflection.jl:9
top-level scope at reflection.jl:25
eval(m::Module, e::Any) at boot.jl:489
include_string(mapexpr::typeof(identity), mod::Module, code::String, filename::String) at loading.jl:2874
_include(mapexpr::Function, mod::Module, _path::String) at loading.jl:2934
include(mod::Module, _path::String) at Base.jl:306
exec_options(opts::Base.JLOptions) at client.jl:317
_start() at client.jl:550

g(1, 2)
#s1#1 at reflection.jl:13 [inlined]
var"#s1#1"(::Any, x::Any, y::Any) at none:0
(::Core.GeneratedFunctionStub)(::UInt64, ::Method, ::Any, ::Vararg{Any}) at expr.jl:1694
call_get_staged at utilities.jl:103 [inlined]
get_staged(mi::Core.MethodInstance, world::UInt64) at utilities.jl:88
retrieve_code_info(mi::Core.MethodInstance, world::UInt64) at utilities.jl:121
Compiler.InferenceState(result::Compiler.InferenceResult, cache_mode::UInt8, interp::Compiler.NativeInterpreter) at inferencestate.jl:602
InferenceState at inferencestate.jl:607 [inlined]
typeinf_ext(interp::Compiler.NativeInterpreter, mi::Core.MethodInstance, source_mode::UInt8) at typeinfer.jl:1250
typeinf_ext_toplevel at typeinfer.jl:1439 [inlined]
typeinf_ext_toplevel(mi::Core.MethodInstance, world::UInt64, source_mode::UInt8, trim_mode::UInt8) at typeinfer.jl:1448
top-level scope at reflection.jl:26
eval(m::Module, e::Any) at boot.jl:489
include_string(mapexpr::typeof(identity), mod::Module, code::String, filename::String) at loading.jl:2874
_include(mapexpr::Function, mod::Module, _path::String) at loading.jl:2934
include(mod::Module, _path::String) at Base.jl:306
exec_options(opts::Base.JLOptions) at client.jl:317
_start() at client.jl:550
=#

end # module test_base_reflection_generator


# from julia/base/expr.jl
#=
function compute_assumed_setting(override::EffectsOverride, @nospecialize(setting), val::Bool=true)
    if isexpr(setting, :call) && setting.args[1] === :(!)
        return compute_assumed_setting(override, setting.args[2], !val)
    elseif isa(setting, QuoteNode)
        return compute_assumed_setting(override, setting.value, val)
    end
    if setting === :consistent
        return EffectsOverride(override; consistent = val)
    elseif setting === :effect_free
        return EffectsOverride(override; effect_free = val)
    elseif setting === :nothrow
        return EffectsOverride(override; nothrow = val)
    elseif setting === :terminates_globally
        return EffectsOverride(override; terminates_globally = val)
    elseif setting === :terminates_locally
        return EffectsOverride(override; terminates_locally = val)
    elseif setting === :notaskstate
        return EffectsOverride(override; notaskstate = val)
    elseif setting === :inaccessiblememonly
        return EffectsOverride(override; inaccessiblememonly = val)
    elseif setting === :noub
        return EffectsOverride(override; noub = val)
    elseif setting === :noub_if_noinbounds
        return EffectsOverride(override; noub_if_noinbounds = val)
    elseif setting === :foldable
        consistent = effect_free = terminates_globally = noub = nortcall = val
        return EffectsOverride(override; consistent, effect_free, terminates_globally, noub, nortcall)
    elseif setting === :removable
        effect_free = nothrow = terminates_globally = val
        return EffectsOverride(override; effect_free, nothrow, terminates_globally)
    elseif setting === :total
        consistent = effect_free = nothrow = terminates_globally = notaskstate =
            inaccessiblememonly = noub = nortcall = val
        return EffectsOverride(override;
            consistent, effect_free, nothrow, terminates_globally, notaskstate,
            inaccessiblememonly, noub, nortcall)
    end
    return nothing
end
=#

# from julia/Compiler/src/typeinfer.jl
#=
function adjust_effects(ipo_effects::Effects, def::Method)
    # override the analyzed effects using manually annotated effect settings
    override = decode_effects_override(def.purity)
    if is_effect_overridden(override, :consistent)
        ipo_effects = Effects(ipo_effects; consistent=ALWAYS_TRUE)
    end
    if is_effect_overridden(override, :effect_free)
        ipo_effects = Effects(ipo_effects; effect_free=ALWAYS_TRUE)
    end
    if is_effect_overridden(override, :nothrow)
        ipo_effects = Effects(ipo_effects; nothrow=true)
    end
    if is_effect_overridden(override, :terminates_globally)
        ipo_effects = Effects(ipo_effects; terminates=true)
    end
    if is_effect_overridden(override, :notaskstate)
        ipo_effects = Effects(ipo_effects; notaskstate=true)
    end
    if is_effect_overridden(override, :inaccessiblememonly)
        ipo_effects = Effects(ipo_effects; inaccessiblememonly=ALWAYS_TRUE)
    end
    if is_effect_overridden(override, :noub)
        ipo_effects = Effects(ipo_effects; noub=ALWAYS_TRUE)
    elseif is_effect_overridden(override, :noub_if_noinbounds) && ipo_effects.noub !== ALWAYS_TRUE
        ipo_effects = Effects(ipo_effects; noub=NOUB_IF_NOINBOUNDS)
    end
    if is_effect_overridden(override, :consistent_overlay)
        ipo_effects = Effects(ipo_effects; nonoverlayed=CONSISTENT_OVERLAY)
    end
    if is_effect_overridden(override, :nortcall)
        ipo_effects = Effects(ipo_effects; nortcall=true)
    end
    return ipo_effects
end
=#
