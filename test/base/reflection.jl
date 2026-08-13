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


module test_base_reflection_infer_effects

using Test

# julia/base/strings/util.jl
# @assume_effects :removable :foldable function chomp(s::Union{String, SubString{String}})
effects = Base.infer_effects(chomp, Tuple{Union{String, SubString{String}}})
if VERSION >= v"1.13.0-DEV.544"
    # :removable                  +e,    +n,+t
    # :foldable                +c,+e,       +t,      +u,   +r
    @test string(effects) == "(+c,+e,!re,+n,+t,!s,!m,+u,+o,+r)"
elseif VERSION >= v"1.12-beta"
    @test string(effects) == "(!c,!e,!n,!t,!s,!m,!u,+o,!r)"
else
    #                                               !o
    @test string(effects) == "(!c,!e,!n,!t,!s,!m,!u,!o,!r)"
end

end # module test_base_reflection_infer_effects
