using Jive
@If VERSION >= v"1.12" module test_stdlibs_InteractiveUtils_macros

using Test
using InteractiveUtils: @activate

# @activate Compiler
# @activate Compiler[:reflection]
# @activate Compiler[:codegen]
# @activate JuliaLowering

# from julia/stdlib/InteractiveUtils/src/macros.jl
# macro activate(what)

using Core.Compiler: Compiler as CC
CC.activate!
# from julia/Compiler/src/bootstrap.jl
#=
function activate!(; reflection=true, codegen=false)
    if reflection
        Base.REFLECTION_COMPILER[] = Compiler
    end
    if codegen
        bootstrap!()
    end
end
=#

end # module test_stdlibs_InteractiveUtils_macros
