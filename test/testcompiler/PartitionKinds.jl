using Jive
@If VERSION >= v"1.13.0-DEV.151" module test_testcompiler_PartitionKinds

using Test
using TestCompiler.PartitionKinds # PartitionKind kinds
                                  # CONST CONST_IMPORT GLOBAL IMPLICIT_GLOBAL IMPLICIT_CONST
                                  # EXPLICIT IMPORTED FAILED DECLARED GUARD UNDEF_CONST BACKDATED_CONST

function sprint_plain(x)::String
    sprint(io -> show(io, MIME"text/plain"(), x))
end

@test PartitionKind(0x9) == PartitionKind(Base.PARTITION_KIND_GUARD)
@test string(PartitionKind(Base.PARTITION_KIND_GUARD)) == "TestCompiler.PartitionKinds.PartitionKind(0x09)"
@test sprint_plain(PartitionKind(Base.PARTITION_KIND_GUARD)) ==
      """const PARTITION_KIND_GUARD = 0x9\n  Guard: The binding was looked at, but no global or import was resolved at\n  the time\n\n  ->restriction is NULL."""

@test              kinds(Base.is_defined_const_binding)  ==  (CONST, CONST_IMPORT, IMPLICIT_CONST, BACKDATED_CONST)
@test sprint_plain(kinds(Base.is_defined_const_binding)) == "(CONST, CONST_IMPORT, IMPLICIT_CONST, BACKDATED_CONST)"

end # module test_testcompiler_PartitionKinds
