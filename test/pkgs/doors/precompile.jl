module test_pkgs_doors_precompile

pkgid = Base.PkgId(Base.UUID("562d782d-cdb6-40a5-8f18-d6f69b5e6b90"), "Doors")
if VERSION >= v"1.12"
precompiled = Base.Precompilation.precompilepkgs([pkgid])
end

end # module test_pkgs_doors_precompile
