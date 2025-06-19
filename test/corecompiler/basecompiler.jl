module test_corecompiler_basecompiler

using Test

if VERSION >= v"1.12.0-DEV.1581"
@test isdefined(Base, :Compiler)
using Base: Compiler as BC
using Core: Compiler as CC
@test BC === CC
else
@test !isdefined(Base, :Compiler)
end

end # module test_corecompiler_basecompiler
