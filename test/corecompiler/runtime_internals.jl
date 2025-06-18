module test_corecompiler_runtime_internals

using Test

@test Base.datatype_fieldcount(Tuple)            == nothing
@test Base.datatype_fieldcount(Int)              == 0
@test Base.datatype_fieldcount(typeof(+))        == 0
@test Base.datatype_fieldcount(Tuple{Int})       == 1
@test Base.datatype_fieldcount(Vector{Int})      == 2
@test Base.datatype_fieldcount(NTuple{100, Int}) == 100

end # module test_corecompiler_runtime_internals
