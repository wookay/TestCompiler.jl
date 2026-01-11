module test_corecompiler_type_infer

using Test
using Core: Compiler as CC

# from julia/Compiler/src/typeinfer.jl
#=
"""
    SOURCE_MODE_NOT_REQUIRED

Indicates to inference that the source is not required and the only fields of
the resulting `CodeInstance` that the caller is interested in are return or
exception types and IPO effects. Inference is still free to create source for
it or add it to the JIT even, but is not required or expected to do so.
"""
const SOURCE_MODE_NOT_REQUIRED = 0x0

"""
    SOURCE_MODE_ABI

Indicates to inference that it should return a CodeInstance that can
be `->invoke`'d (because it has already been compiled).
"""
const SOURCE_MODE_ABI = 0x1

"""
    SOURCE_MODE_GET_SOURCE

Indicates to inference that it should return a CodeInstance after it has
prepared interp to be able to provide source code for it.
"""
const SOURCE_MODE_GET_SOURCE = 0xf


"""
    ci_has_abi(interp::AbstractInterpreter, code::CodeInstance)

Determine whether this CodeInstance is something that could be invoked if
interp gave it to the runtime system (either because it already has an ->invoke
ptr, or because interp has source that could be compiled).
"""
function ci_has_abi(interp::AbstractInterpreter, code::CodeInstance)

"""
    ci_has_source(interp::AbstractInterpreter, code::CodeInstance)

Determine whether this CodeInstance is something that will return something
compileable by ci_get_source.
"""
function ci_has_source(interp::AbstractInterpreter, code::CodeInstance)

# Get source if available for inlining, otherwise return nothing
# populates codegen cache for code, if successful
function ci_get_source(interp::AbstractInterpreter, code::CodeInstance, @nospecialize src)
function ci_get_source(interp::AbstractInterpreter, code::CodeInstance)

function ci_has_invoke(code::CodeInstance)

# compute (and cache) an inferred AST and return type
function typeinf_ext(interp::AbstractInterpreter, mi::MethodInstance, source_mode::UInt8)
=#

end # module test_corecompiler_type_infer
