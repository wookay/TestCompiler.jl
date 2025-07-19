module test_corecompiler_runtime_internals

using Test

@test Base.datatype_fieldcount(Tuple)            == nothing
@test Base.datatype_fieldcount(Int)              == 0
@test Base.datatype_fieldcount(typeof(+))        == 0
@test Base.datatype_fieldcount(Tuple{Int})       == 1
@test Base.datatype_fieldcount(Vector{Int})      == 2
@test Base.datatype_fieldcount(NTuple{100, Int}) == 100

end # module test_corecompiler_runtime_internals


using Jive
# @__FUNCTION__  julia commit bea90a2f503018115b30559b9d6838c05a86b9b4
@If VERSION >= v"1.13.0-DEV.878" module test_corecompiler_runtime_internals__function_macro

using Test

function f()
    @__FUNCTION__
end

@test f() === f

end # module test_corecompiler_runtime_internals__function_macro
