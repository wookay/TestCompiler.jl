module test_corecompiler_tfuncs

using Test
using Core.Compiler: @nospecs

f(x) = nothing
f(1)
f("")
f(3.14)

mf = only(methods(f))
@test mf.specializations isa Core.SimpleVector


@nospecs g(x) = nothing
g(1)
g("")
g(3.14)

mg = only(methods(g))
mgi = mg.specializations
@test mgi isa Core.MethodInstance
@test mgi.specTypes === Tuple{typeof(g), Any}

end # module test_corecompiler_tfuncs
