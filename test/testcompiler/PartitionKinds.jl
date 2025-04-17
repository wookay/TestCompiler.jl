using Jive
@If VERSION >= v"1.13.0-DEV.151" module test_testcompiler_PartitionKinds

using Test
using TestCompiler.PartitionKinds # PartitionKind kinds
                                  # CONST CONST_IMPORT GLOBAL IMPLICIT_GLOBAL IMPLICIT_CONST
                                  # EXPLICIT IMPORTED FAILED DECLARED GUARD UNDEF_CONST BACKDATED_CONST
using Jive # sprint_plain

@test PartitionKind(0x9) == PartitionKind(Base.PARTITION_KIND_GUARD)
@test string(PartitionKind(Base.PARTITION_KIND_GUARD)) == "TestCompiler.PartitionKinds.PartitionKind(0x09)"
@test sprint_plain(PartitionKind(Base.PARTITION_KIND_GUARD)) ==
      """const PARTITION_KIND_GUARD = 0x9\n  Guard: The binding was looked at, but no global or import was resolved at\n  the time\n\n  ->restriction is NULL."""

@test sprint_plain(kinds(Base.is_defined_const_binding)) == "(CONST, CONST_IMPORT, IMPLICIT_CONST, BACKDATED_CONST)"
@test kinds(Base.is_defined_const_binding)  == (CONST, CONST_IMPORT, IMPLICIT_CONST, BACKDATED_CONST)
@test kinds(Base.is_some_const_binding)     == (kinds(Base.is_defined_const_binding)..., UNDEF_CONST) ==
                                               (CONST, CONST_IMPORT, IMPLICIT_CONST, BACKDATED_CONST, UNDEF_CONST)
@test kinds(Base.is_some_imported)          == (IMPLICIT_GLOBAL, IMPLICIT_CONST, EXPLICIT, IMPORTED) ==
                                               (IMPLICIT_GLOBAL, IMPLICIT_CONST, kinds(Base.is_some_explicit_imported)...)
@test kinds(Base.is_some_implicit)          == (IMPLICIT_GLOBAL, IMPLICIT_CONST, GUARD, FAILED)
@test kinds(Base.is_some_explicit_imported) == (EXPLICIT, IMPORTED)
@test kinds(Base.is_some_binding_imported)  == (kinds(Base.is_some_explicit_imported)..., IMPLICIT_GLOBAL) ==
                                               (EXPLICIT, IMPORTED, IMPLICIT_GLOBAL)
@test kinds(Base.is_some_guard)             == (GUARD, FAILED, UNDEF_CONST)

using .PartitionKinds.Enums: PARTITION_KIND
for enum_kind in instances(PARTITION_KIND)
    kind = UInt8(enum_kind)
    for f in (Base.is_defined_const_binding,
              Base.is_some_const_binding,
              Base.is_some_imported,
              Base.is_some_implicit,
              Base.is_some_explicit_imported,
              Base.is_some_binding_imported,
              Base.is_some_guard)
        if PartitionKind(kind) in kinds(f)
            @test f(kind)
        else
            @test !f(kind)
        end
    end
end

end # module test_testcompiler_PartitionKinds
