module test_corecompiler_access_to_globals

using Test

@test isdefined(Base, Symbol("@isdefined"))
@test @isdefined isdefined

module M; global a; end;
@test !isdefined(M, :a)

if VERSION >= v"1.12" # isdefinedglobal
@test !isdefinedglobal(M, :a)
@test isdefinedglobal(Base, :isdefinedglobal)
end # if VERSION >= v"1.12"


if VERSION >= v"1.9" # getglobal setglobal!
∑  = getglobal(Base, :sum)
@test ∑([1, 2]) == 3
setglobal!(M, :a, 1)
@test getglobal(M, :a) == 1
@test isdefined(M, :a)
end # if VERSION >= v"1.9"


if VERSION >= v"1.12"
@test isdefinedglobal(M, :a)
end # if VERSION >= v"1.12"

end # module test_corecompiler_access_to_globals
