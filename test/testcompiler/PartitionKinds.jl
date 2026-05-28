using Jive
@If VERSION >= v"1.13.0-DEV.151" module test_testcompiler_PartitionKinds

using Test
using TestCompiler.PartitionKinds # PartitionKind kinds
                                  # CONST CONST_IMPORT GLOBAL IMPLICIT_GLOBAL IMPLICIT_CONST
                                  # EXPLICIT IMPORTED FAILED DECLARED GUARD UNDEF_CONST BACKDATED_CONST
using LogicalOperators: OR

@test PartitionKind(0x9) == PartitionKind(Base.PARTITION_KIND_GUARD)
@test string(PartitionKind(Base.PARTITION_KIND_GUARD)) == "TestCompiler.PartitionKinds.PartitionKind(0x09)"

@test kinds(Base.is_defined_const_binding)  == OR(CONST, CONST_IMPORT, IMPLICIT_CONST, BACKDATED_CONST)
@test kinds(Base.is_some_const_binding)     == OR(kinds(Base.is_defined_const_binding)..., UNDEF_CONST) ==
                                               OR(CONST, CONST_IMPORT, IMPLICIT_CONST, BACKDATED_CONST, UNDEF_CONST)
@test kinds(Base.is_some_imported)          == OR(IMPLICIT_GLOBAL, IMPLICIT_CONST, EXPLICIT, IMPORTED) ==
                                               OR(IMPLICIT_GLOBAL, IMPLICIT_CONST, kinds(Base.is_some_explicit_imported)...)
@test kinds(Base.is_some_implicit)          == OR(IMPLICIT_GLOBAL, IMPLICIT_CONST, GUARD, FAILED)
@test kinds(Base.is_some_explicit_imported) == OR(EXPLICIT, IMPORTED)
@test kinds(Base.is_some_binding_imported)  == OR(kinds(Base.is_some_explicit_imported)..., IMPLICIT_GLOBAL) ==
                                               OR(EXPLICIT, IMPORTED, IMPLICIT_GLOBAL)
@test kinds(Base.is_some_guard)             == OR(GUARD, FAILED, UNDEF_CONST)

on_ci = haskey(ENV, "CI")

using .PartitionKinds.Enums: PARTITION_KIND
for enum_kind in instances(PARTITION_KIND)
    n = UInt8(enum_kind)
    partition = PartitionKind(n)
    for f in (Base.is_defined_const_binding,
              Base.is_some_const_binding,
              Base.is_some_imported,
              Base.is_some_implicit,
              Base.is_some_explicit_imported,
              Base.is_some_binding_imported,
              Base.is_some_guard)
        if partition in kinds(f)
            @test f(n)
        else
            @test !f(n)
        end
    end
    if on_ci
        Base.show(stdout, MIME"text/plain"(), partition)
    end
end

end # module test_testcompiler_PartitionKinds
