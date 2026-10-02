module test_core_codegen

using Test

# from julia/src/codegen.cpp

scope = Core.current_scope()
if VERSION >= v"1.14-DEV"
for (k, v) in scope.values
    if k isa Base.ScopedValues.ScopedValue && k[] isa Base.VersionedParse
        @test k[].edition == (1, 14)
    end
end
end # if

if VERSION >= v"1.14.0-DEV.3468" # julia commit ede60fbcca
primitive type Int3 3 end
@test sizeof(Int3) == 1
@test Core.bitsizeof(Int3) == 3
end

end # module test_core_codegen
