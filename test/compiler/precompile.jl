using Jive
@If VERSION >= v"1.14-DEV" module test_compiler_precompile

using Test
using Pkg

pkgid = Base.PkgId(Base.UUID("807dbc54-b67e-4c79-8afb-eafe4df6f2e1"), "Compiler")
loaded = haskey(Base.loaded_modules, pkgid)
@test Pkg.depots1() == DEPOT_PATH[1] # $HOME/.julia
ver = string("v", VERSION.major, ".", VERSION.minor)
@test joinpath(Pkg.depots1(), "compiled", ver, "Compiler") == Base.compilecache_dir(pkgid) # $HOME/.julia/compiled/v1.14/Compiler

using Compiler
loaded = haskey(Base.loaded_modules, pkgid)
@test loaded

pkgs = [pkgid]
precompiled = Base.Precompilation.precompilepkgs(pkgs)
cachefile = precompiled[1]
@test isfile(cachefile)

end # module test_compiler_precompile
