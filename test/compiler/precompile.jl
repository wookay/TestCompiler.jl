using Jive
@If VERSION >= v"1.14-DEV" module test_compiler_precompile

using Test

pkgid = Base.PkgId(Base.UUID("807dbc54-b67e-4c79-8afb-eafe4df6f2e1"), "Compiler")
loaded = haskey(Base.loaded_modules, pkgid)
if isdir(DEPOT_PATH[1])
@test isdir(Base.compilecache_dir(pkgid))
end

using Compiler
loaded = haskey(Base.loaded_modules, pkgid)
@test loaded

pkgs = [pkgid]
precompiled = Base.Precompilation.precompilepkgs(pkgs)
cachefile = precompiled[1]
@test isfile(cachefile)

end # module test_compiler_precompile
