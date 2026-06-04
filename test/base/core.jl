module test_base_core_redefining_structs

# see also base/essentials.jl

using Test

# from julia/test/core.jl

struct T36104
    x
end
const orig_T36104 = T36104

# check that redefining it works  # julia issue #21816
struct T36104
    x
end

@test orig_T36104 === T36104


# self-referential struct redefinition must reuse the binding  # julia issue #61789
struct R61789
    x
    next::R61789
end
const orig_R61789 = R61789
world1 = Base.get_world_counter()

struct R61789
    x
    next::R61789
end
world2 = Base.get_world_counter()

# from julia/base/essentials.jl
@test orig_R61789 === Base.invoke_in_world(world1, Core.getglobal, @__MODULE__, :R61789)

if v"1.13" > VERSION >= v"1.12"
@test orig_R61789 !== Base.invoke_in_world(world2, Core.getglobal, @__MODULE__, :R61789)
@test orig_R61789 !== R61789
else
@test orig_R61789 === Base.invoke_in_world(world2, Core.getglobal, @__MODULE__, :R61789)
@test orig_R61789 === R61789
end


# negative case: a field type that genuinely differs must produce a new type
struct R61789neg
    x
end
const orig_R61789neg = R61789neg

if VERSION >= v"1.12"
struct R61789neg
    x::Int
end

@test orig_R61789neg !== R61789neg
end # if

end # module test_base_core_redefining_structs


module test_base_core_typeeq

using Test

if VERSION >= v"1.14.0-DEV.2291" # julia commit 26145852c4
Core.TypeEq
Base.isType
Base.type_parameter

@test Union isa Core.AnyType
@test Union isa supertype(Union)
@test UnionAll isa Core.AnyType
@test UnionAll isa supertype(UnionAll)
end

end # module test_base_core_typeeq
