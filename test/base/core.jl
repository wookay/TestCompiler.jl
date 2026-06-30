module test_base_core_redefining_structs

# see also base/essentials.jl

using Test

# from julia/test/core.jl

struct T36104
    x
end
const orig_T36104 = T36104

# WARNING: Method definition T36104(Any)
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

# WARNING: Method definition R61789(Any, R61789)
# WARNING: Method definition R61789(Any, Any)
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

@test !isconcretetype(Vector)
@test  isconcretetype(Vector{Int})
@test  isconcretetype(Union)
@test  isconcretetype(Union{Int})
@test  isconcretetype(UnionAll)
@test !isconcretetype(Any)
@test !isconcretetype(Type)

@test !isabstracttype(Vector)
@test !isabstracttype(Vector{Int})
@test !isabstracttype(Union)
@test !isabstracttype(Union{Int})
@test !isabstracttype(UnionAll)
@test  isabstracttype(Any)
@test  isabstracttype(Type)

@test Union    <: Any
@test UnionAll <: Any

@test   Vector      isa UnionAll
@test !(Vector{Int} isa UnionAll)

if VERSION >= v"1.14.0-DEV.2291" # julia commit 26145852c4
@test Union    isa supertype(Union)
@test UnionAll isa supertype(UnionAll)
@test_throws MethodError supertype(Type)         <: Any
@test_throws MethodError supertype(Type{Vector}) <: Any

@test Union    <: Core.AnyType <: Any
@test UnionAll <: Core.AnyType <: Any

@test !isconcretetype(Core.AnyType)
@test  isabstracttype(Core.AnyType)

Core.TypeEq
@test supertype(TypeEq) === Core.AnyType
@test  TypeEq             <: Core.AnyType
@test (TypeEq{T} where T) <: Core.AnyType
@test Type         !== TypeEq
@test Type{Vector} === TypeEq{Vector}

# from julia/base/runtime_internals.jl
Base.isType
# isType(@nospecialize t) = isa(t, TypeEq)

Base.type_parameter
# type_parameter(t::TypeEq) = getfield(t, :T)

@test hasmethod(Base.type_parameter, (Core.TypeEq,))

@test Base.isType(Type{Vector})
@test Base.isType(Type{Broadcast.Broadcasted})

@test Base.type_parameter(Type{Vector}) ===
      Base.type_parameter(TypeEq{Vector}) ===
      Vector
else
@test (Union    isa supertype(Union))    === false
@test (UnionAll isa supertype(UnionAll)) === false
@test supertype(Type)         <: Any
@test supertype(Type{Vector}) <: Any
end # if

end # module test_base_core_typeeq
