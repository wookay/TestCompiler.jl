module test_core_codegen

using Test

# from julia/src/codegen.cpp

scope = Core.current_scope()
if VERSION >= v"1.14-DEV"
for (k, v) in scope.values
    if k isa Base.ScopedValues.ScopedValue && k[] isa Base.VersionedParse
        @test k[].ver >= v"1.14.0-DEV.2635"
    end
end
end # if

end # module test_core_codegen
