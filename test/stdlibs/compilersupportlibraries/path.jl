module test_stdlibs_compilersupportlibraries_path

using Test
using CompilerSupportLibraries_jll: CompilerSupportLibraries_jll as L

if VERSION >= v"1.13.0-DEV.718" # julia commit 5610e21199
@test isfile(L.libatomic_path)
end

end # module test_stdlibs_compilersupportlibraries_path
