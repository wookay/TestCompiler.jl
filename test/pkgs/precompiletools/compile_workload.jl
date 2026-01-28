module test_pkgs_precompiletools_compile_workload

using Test
using PrecompileTools

PrecompileTools.verbose[] = true

struct Glyph
    ch::Char
end

f(glyph::Glyph) = glyph.ch
glyph = Glyph('A')

@compile_workload begin
    f(glyph)
end

# 1.14
#=
MethodInstance for getproperty(::Main.test_pkgs_precompiletools_compile_workload.Glyph, ::Symbol)
MethodInstance for Main.test_pkgs_precompiletools_compile_workload.f(::Main.test_pkgs_precompiletools_compile_workload.Glyph)
MethodInstance for IndexStyle(::Type{Vector{Core.CodeInstance}})
MethodInstance for IndexStyle(::Vector{Core.CodeInstance})
MethodInstance for firstindex(::Vector{Core.CodeInstance})
MethodInstance for Base.iterate_starting_state(::Vector{Core.CodeInstance}, ::IndexLinear)
MethodInstance for Base.iterate_starting_state(::Vector{Core.CodeInstance})
MethodInstance for Base._iterate_abstractarray(::Vector{Core.CodeInstance}, ::Int64)
MethodInstance for iterate(::Vector{Core.CodeInstance}, ::Int64)
MethodInstance for iterate(::Vector{Core.CodeInstance})
MethodInstance for PrecompileTools.tag_newly_inferred_disable()
=#

# 1.12
#=
MethodInstance for getproperty(::Main.test_pkgs_precompiletools_compile_workload.Glyph, ::Symbol)
MethodInstance for Main.test_pkgs_precompiletools_compile_workload.f(::Main.test_pkgs_precompiletools_compile_workload.Glyph)
MethodInstance for iterate(::Vector{Core.CodeInstance}, ::Int64)
MethodInstance for iterate(::Vector{Core.CodeInstance})
MethodInstance for PrecompileTools.tag_newly_inferred_disable()
=#

end # module test_pkgs_precompiletools_compile_workload
