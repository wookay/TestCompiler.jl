using Jive
@If VERSION >= v"1.12" module test_base_rebinding

using Test

# from julia/test/rebinding.jl

module M
    const foo = "unchanged"
end
indirect_access(modref::Module) = Base.getproperty(modref, :foo)::String
caller() = indirect_access(M)

mi = Base.method_instance(caller, ())
@test isdefined(mi, :cache) === false

@test Base.return_types(caller, ()) == Any[String]
mi = Base.method_instance(caller, ())
@test isdefined(mi, :cache) === true
ci = mi.cache

if VERSION >= v"1.14.0-DEV.2290"
@test length(ci.edges[1].edges) == 2
else
@test length(ci.edges[1].edges) == 1
end

@eval M const foo = "changed!"
@test caller() == "changed!"

end # module test_base_rebinding
