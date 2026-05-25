using Jive
@If VERSION >= v"1.13.0-DEV.151" module test_base_partition_kind

# see also base/runtime_internals.jl

using Test
                                    #       levels   test
Base.PARTITION_KIND_CONST           # 0x00        3  o
Base.PARTITION_KIND_CONST_IMPORT    # 0x01        3  o
Base.PARTITION_KIND_GLOBAL          # 0x02        3  o
Base.PARTITION_KIND_IMPLICIT_GLOBAL # 0x03  1        o
Base.PARTITION_KIND_IMPLICIT_CONST  # 0x04  1        o
Base.PARTITION_KIND_EXPLICIT        # 0x05        3  o
Base.PARTITION_KIND_IMPORTED        # 0x06        3  o
Base.PARTITION_KIND_FAILED          # 0x07  1
Base.PARTITION_KIND_DECLARED        # 0x08     2     o
Base.PARTITION_KIND_GUARD           # 0x09  1        o
Base.PARTITION_KIND_UNDEF_CONST     # 0x0a        3
Base.PARTITION_KIND_BACKDATED_CONST # 0x0b

# from julia/test/rebinding.jl

@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_GUARD

struct Foo
    x::Int
end
@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_CONST

Base.delete_binding(@__MODULE__, :Foo)
@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_GUARD

const Foo = 1
@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_CONST

Base.delete_binding(@__MODULE__, :Foo)
@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_GUARD

# from julia/base/runtime_internals.jl
# function lookup_binding_partition(world::UInt, b::Core.Binding)
# function lookup_binding_partition(world::UInt, gr::Core.GlobalRef)
Base.lookup_binding_partition

world1 = Base.get_world_counter()
gr1 = GlobalRef(@__MODULE__, :Foo)
partition1 = Base.lookup_binding_partition(world1, gr1)
@test Base.binding_kind(partition1) == partition1.kind == Base.PARTITION_KIND_GUARD
@test partition1 isa Core.BindingPartition

struct Foo
    x2::Int
end
world2 = Base.get_world_counter()
gr2 = GlobalRef(@__MODULE__, :Foo)
partition2 = Base.lookup_binding_partition(world2, gr2)
@test partition2.kind == Base.PARTITION_KIND_CONST

const const_var = 42
@test Base.binding_kind(@__MODULE__, :const_var) == Base.PARTITION_KIND_CONST

global global_var
@test Base.binding_kind(@__MODULE__, :global_var) == Base.PARTITION_KIND_DECLARED
global_var = 1
@test Base.binding_kind(@__MODULE__, :global_var) == Base.PARTITION_KIND_GLOBAL

@test Base.binding_kind(Base, :pi)        == Base.PARTITION_KIND_EXPLICIT
@test Base.binding_kind(@__MODULE__, :pi) == Base.PARTITION_KIND_IMPLICIT_CONST

module M
export implicit_global_var
implicit_global_var = 3

imported_var = 6
end # module M

using .M
@test Base.binding_kind(M, :implicit_global_var) == Base.PARTITION_KIND_GLOBAL
@test Base.binding_kind(@__MODULE__, :implicit_global_var) == Base.PARTITION_KIND_IMPLICIT_GLOBAL

@test Base.binding_kind(M, :imported_var) == Base.PARTITION_KIND_GLOBAL
@test Base.binding_kind(@__MODULE__, :imported_var) == Base.PARTITION_KIND_GUARD
import .M: imported_var
@test Base.binding_kind(@__MODULE__, :imported_var) == Base.PARTITION_KIND_IMPORTED

import Pkg
@test Base.binding_kind(Pkg, :Pkg) == Base.PARTITION_KIND_CONST
@test Base.binding_kind(@__MODULE__, :Pkg) == Base.PARTITION_KIND_CONST_IMPORT

import Test: Test
@test Base.binding_kind(Test, :Test) == Base.PARTITION_KIND_CONST
@test Base.binding_kind(@__MODULE__, :Test) == Base.PARTITION_KIND_IMPORTED


# from julia/base/runtime_internals.jl
#=
# N.B.: Needs to be synced with julia.h
const PARTITION_KIND_CONST              = 0x0
const PARTITION_KIND_CONST_IMPORT       = 0x1
const PARTITION_KIND_GLOBAL             = 0x2
const PARTITION_KIND_IMPLICIT_GLOBAL    = 0x3
const PARTITION_KIND_IMPLICIT_CONST     = 0x4
const PARTITION_KIND_EXPLICIT           = 0x5
const PARTITION_KIND_IMPORTED           = 0x6
const PARTITION_KIND_FAILED             = 0x7
const PARTITION_KIND_DECLARED           = 0x8
const PARTITION_KIND_GUARD              = 0x9
const PARTITION_KIND_UNDEF_CONST        = 0xa
const PARTITION_KIND_BACKDATED_CONST    = 0xb
=#

# from julia/src/julia.h
#=
// N.B: Needs to be synced with runtime_internals.jl
// We track essentially three levels of binding strength:
//
// 1. Implicit Bindings (Weakest)
//   These binding kinds depend solely on the set of using'd packages and are not explicitly
//   declared:
//
//      PARTITION_KIND_IMPLICIT_CONST
//      PARTITION_KIND_IMPLICIT_GLOBAL
//      PARTITION_KIND_GUARD
//      PARTITION_KIND_FAILED
//
// 2. Weakly Declared Bindings (Weak)
//    The binding was declared using `global`. It is treated as a mutable, `Any` type global
//    for almost all purposes, except that it receives slightly worse optimizations, since it
//    may be replaced.
//
//      PARTITION_KIND_DECLARED
//
// 3. Strong Declared Bindings (Weak)
//    All other bindings are explicitly declared using a keyword or global assignment.
//   These are considered strongest:
//
//      PARTITION_KIND_CONST
//      PARTITION_KIND_CONST_IMPORT
//      PARTITION_KIND_EXPLICIT
//      PARTITION_KIND_IMPORTED
//      PARTITION_KIND_GLOBAL
//      PARTITION_KIND_UNDEF_CONST
//
// The runtime supports syntactic invalidation (by raising the world age and changing the partition type
// in the new world age) from any partition kind to any other.
//
// However, not all transitions are allowed syntactically. We have the following rules for SYNTACTIC invalidation:
// 1. It is always syntactically permissible to replace a weaker binding by a stronger binding
// 2. Implicit bindings can be syntactically changed to other implicit bindings by changing the `using` set.
// 3. Finally, we syntactically permit replacing one PARTITION_KIND_CONST(_IMPORT) by another of a different value.
//
// We may make this list more permissive in the future.
//
// Finally, PARTITION_KIND_BACKDATED_CONST is a special case, and the only case where we may replace an
// existing partition by a different partition kind in the same world age. As such, it needs special
// support in inference. Any partition kind that may be replaced by a PARTITION_KIND_BACKDATED_CONST
// must be inferred accordingly. PARTITION_KIND_BACKDATED_CONST is intended as a temporary compatibility
// measure. The following kinds may be replaced by PARTITION_KIND_BACKDATED_CONST:
//  - PARTITION_KIND_GUARD
//  - PARTITION_KIND_FAILED
//  - PARTITION_KIND_DECLARED
enum jl_partition_kind {
    // Constant: This binding partition is a constant declared using `const _ = ...`
    //  ->restriction holds the constant value
    PARTITION_KIND_CONST        = 0x0,
    // Import Constant: This binding partition is a constant declared using `import A`
    //  ->restriction holds the constant value
    PARTITION_KIND_CONST_IMPORT = 0x1,
    // Global: This binding partition is a global variable. It was declared either using
    // `global x::T` to implicitly through a syntactic global assignment.
    //  -> restriction holds the type restriction
    PARTITION_KIND_GLOBAL       = 0x2,
    // Implicit: The binding was a global, implicitly imported from a `using`'d module.
    //  ->restriction holds the ultimately imported global binding
    PARTITION_KIND_IMPLICIT_GLOBAL     = 0x3,
    // Implicit: The binding was a constant, implicitly imported from a `using`'d module.
    //  ->restriction holds the ultimately imported constant value
    PARTITION_KIND_IMPLICIT_CONST     = 0x4,
    // Explicit: The binding was explicitly `using`'d by name
    //  ->restriction holds the imported binding
    PARTITION_KIND_EXPLICIT     = 0x5,
    // Imported: The binding was explicitly `import`'d by name
    //  ->restriction holds the imported binding
    PARTITION_KIND_IMPORTED     = 0x6,
    // Failed: We attempted to import the binding, but the import was ambiguous
    //  ->restriction is NULL.
    PARTITION_KIND_FAILED       = 0x7,
    // Declared: The binding was declared using `global` or similar. This acts in most ways like
    // PARTITION_KIND_GLOBAL with an `Any` restriction, except that it may be redefined to a stronger
    // binding like `const` or an explicit import.
    //  ->restriction is NULL.
    PARTITION_KIND_DECLARED     = 0x8,
    // Guard: The binding was looked at, but no global or import was resolved at the time
    //  ->restriction is NULL.
    PARTITION_KIND_GUARD        = 0x9,
    // Undef Constant: This binding partition is a constant declared using `const`, but
    // without a value.
    //  ->restriction is NULL
    PARTITION_KIND_UNDEF_CONST  = 0xa,
    // Backated constant. A constant that was backdated for compatibility. In all other
    // ways equivalent to PARTITION_KIND_CONST, but prints a warning on access
    PARTITION_KIND_BACKDATED_CONST = 0xb,

    // This is not a real binding kind, but can be used to ask for a re-resolution
    // of the implicit binding kind
    PARTITION_FAKE_KIND_IMPLICIT_RECOMPUTE = 0xc,
    PARTITION_FAKE_KIND_CYCLE = 0xd
};
=#

end # module test_base_partition_kind
