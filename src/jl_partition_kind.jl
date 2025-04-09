# module TestCompiler

export PartitionKind

struct PartitionKind
    kind::UInt8
end

public      PARTITION_KIND_CONST,
            PARTITION_KIND_CONST_IMPORT,
            PARTITION_KIND_GLOBAL,
            PARTITION_KIND_IMPLICIT_GLOBAL,
            PARTITION_KIND_IMPLICIT_CONST,
            PARTITION_KIND_EXPLICIT,
            PARTITION_KIND_IMPORTED,
            PARTITION_KIND_FAILED,
            PARTITION_KIND_DECLARED,
            PARTITION_KIND_GUARD,
            PARTITION_KIND_UNDEF_CONST,
            PARTITION_KIND_BACKDATED_CONST


module PartitionKinds # TestCompiler
# from julia/base/runtime_internals.jl
@enum(PARTITION_KIND,
      PARTITION_KIND_CONST              = 0x0,
      PARTITION_KIND_CONST_IMPORT       = 0x1,
      PARTITION_KIND_GLOBAL             = 0x2,
      PARTITION_KIND_IMPLICIT_GLOBAL    = 0x3,
      PARTITION_KIND_IMPLICIT_CONST     = 0x4,
      PARTITION_KIND_EXPLICIT           = 0x5,
      PARTITION_KIND_IMPORTED           = 0x6,
      PARTITION_KIND_FAILED             = 0x7,
      PARTITION_KIND_DECLARED           = 0x8,
      PARTITION_KIND_GUARD              = 0x9,
      PARTITION_KIND_UNDEF_CONST        = 0xa,
      PARTITION_KIND_BACKDATED_CONST    = 0xb,
)
end # module TestCompiler.PartitionKinds


if VERSION >= v"1.13.0-DEV.280"
using Base: PARTITION_KIND_CONST,
            PARTITION_KIND_CONST_IMPORT,
            PARTITION_KIND_GLOBAL,
            PARTITION_KIND_IMPLICIT_GLOBAL,
            PARTITION_KIND_IMPLICIT_CONST,
            PARTITION_KIND_EXPLICIT,
            PARTITION_KIND_IMPORTED,
            PARTITION_KIND_FAILED,
            PARTITION_KIND_DECLARED,
            PARTITION_KIND_GUARD,
            PARTITION_KIND_UNDEF_CONST,
            PARTITION_KIND_BACKDATED_CONST
else
using .PartitionKinds:
            PARTITION_KIND_CONST,
            PARTITION_KIND_CONST_IMPORT,
            PARTITION_KIND_GLOBAL,
            PARTITION_KIND_IMPLICIT_GLOBAL,
            PARTITION_KIND_IMPLICIT_CONST,
            PARTITION_KIND_EXPLICIT,
            PARTITION_KIND_IMPORTED,
            PARTITION_KIND_FAILED,
            PARTITION_KIND_DECLARED,
            PARTITION_KIND_GUARD,
            PARTITION_KIND_UNDEF_CONST,
            PARTITION_KIND_BACKDATED_CONST
end # if VERSION >= v"1.13.0-DEV.280"


# from julia/src/julia.h
"""
N.B: Needs to be synced with runtime_internals.jl
We track essentially three levels of binding strength:

1. Implicit Bindings (Weakest)
  These binding kinds depend solely on the set of using'd packages and are not explicitly
  declared:

     PARTITION_KIND_IMPLICIT_CONST
     PARTITION_KIND_IMPLICIT_GLOBAL
     PARTITION_KIND_GUARD
     PARTITION_KIND_FAILED

2. Weakly Declared Bindings (Weak)
   The binding was declared using `global`. It is treated as a mutable, `Any` type global
2. Weakly Declared Bindings (Weak)
   The binding was declared using `global`. It is treated as a mutable, `Any` type global
   for almost all purposes, except that it receives slightly worse optimizations, since it
   may be replaced.

     PARTITION_KIND_DECLARED

3. Strong Declared Bindings (Weak)
   All other bindings are explicitly declared using a keyword or global assignment.
  These are considered strongest:

     PARTITION_KIND_CONST
     PARTITION_KIND_CONST_IMPORT
     PARTITION_KIND_EXPLICIT
     PARTITION_KIND_IMPORTED
     PARTITION_KIND_GLOBAL
     PARTITION_KIND_UNDEF_CONST

The runtime supports syntactic invalidation (by raising the world age and changing the partition type
in the new world age) from any partition kind to any other.

However, not all transitions are allowed syntactically. We have the following rules for SYNTACTIC invalidation:
1. It is always syntactically permissable to replace a weaker binding by a stronger binding
2. Implicit bindings can be syntactically changed to other implicit bindings by changing the `using` set.
3. Finally, we syntactically permit replacing one PARTITION_KIND_CONST(_IMPORT) by another of a different value.

We may make this list more permissive in the future.

Finally, PARTITION_KIND_BACKDATED_CONST is a special case, and the only case where we may replace an
existing partition by a different partition kind in the same world age. As such, it needs special
support in inference. Any partition kind that may be replaced by a PARTITION_KIND_BACKDATED_CONST
must be inferred accordingly. PARTITION_KIND_BACKDATED_CONST is intended as a temporary compatibility
measure. The following kinds may be replaced by PARTITION_KIND_BACKDATED_CONST:
 - PARTITION_KIND_GUARD
 - PARTITION_KIND_FAILED
 - PARTITION_KIND_DECLARED
"""
jl_partition_kind

    """
    Constant: This binding partition is a constant declared using `const _ = ...`

     ->restriction holds the constant value
    """
    PARTITION_KIND_CONST

    """
    Import Constant: This binding partition is a constant declared using `import A`

     ->restriction holds the constant value
    """
    PARTITION_KIND_CONST_IMPORT

    """
    Global: This binding partition is a global variable. It was declared either using
    `global x::T` to implicitly through a syntactic global assignment.

     -> restriction holds the type restriction
    """
    PARTITION_KIND_GLOBAL

    """
    Implicit: The binding was a global, implicitly imported from a `using`'d module.

     ->restriction holds the ultimately imported global binding
    """
    PARTITION_KIND_IMPLICIT_GLOBAL

    """
    Implicit: The binding was a constant, implicitly imported from a `using`'d module.

     ->restriction holds the ultimately imported constant value
    """
    PARTITION_KIND_IMPLICIT_CONST

    """
    Explicit: The binding was explicitly `using`'d by name

     ->restriction holds the imported binding
    """
    PARTITION_KIND_EXPLICIT

    """
    Imported: The binding was explicitly `import`'d by name

     ->restriction holds the imported binding
    """
    PARTITION_KIND_IMPORTED

    """
    Failed: We attempted to import the binding, but the import was ambiguous

     ->restriction is `NULL`.
    """
    PARTITION_KIND_FAILED

    """
    Declared: The binding was declared using `global` or similar. This acts in most ways like
    `PARTITION_KIND_GLOBAL` with an `Any` restriction, except that it may be redefined to a stronger
    binding like `const` or an explicit import.

     ->restriction is `NULL`.
    """
    PARTITION_KIND_DECLARED

    """
    Guard: The binding was looked at, but no global or import was resolved at the time

     ->restriction is `NULL`.
    """
    PARTITION_KIND_GUARD

    """
    Undef Constant: This binding partition is a constant declared using `const`, but
    without a value.

     ->restriction is `NULL`
    """
    PARTITION_KIND_UNDEF_CONST

    """
    Backated constant. A constant that was backdated for compatibility. In all other
    ways equivalent to `PARTITION_KIND_CONST`, but prints a warning on access
    """
    PARTITION_KIND_BACKDATED_CONST

    """
    This is not a real binding kind, but can be used to ask for a re-resolution
    of the implicit binding kind
    """
    PARTITION_FAKE_KIND_IMPLICIT_RECOMPUTE,
    PARTITION_FAKE_KIND_CYCLE


using REPL

function Base.show(io::IO, mime::MIME"text/plain", partition::PartitionKind)
    sym = Symbol(PartitionKinds.PARTITION_KIND(partition.kind))
    printstyled(io, "const ", color = :light_green, )
    printstyled(io, sym, color = :cyan)
    printstyled(io, " = ", color = :light_green)
    printstyled(io, "0x", string(partition.kind, base=16, pad = 1), color = :light_red)
    println(io)
    doc = REPL.doc(Base.Docs.Binding(@__MODULE__, sym))
    Base.show(io, mime, doc)
end

# module TestCompiler
