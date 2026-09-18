module test_base_hashing

using Test

=== # egal
objectid
hash
==
isequal
in
identity

# from julia/base/
# abstractdict.jl function hash(a::AbstractDict, h::UInt)
# complex.jl      function hash(z::Complex, h::UInt)
# gmp.jl          function hash(x::BigInt, h::UInt)
# hashing.jl               hash(@nospecialize(data), h::UInt) = hash(objectid(data), h)
# hashing.jl               hash(w::WeakRef, h::UInt)
# hashing.jl               hash(T::Type, h::UInt)
# hashing.jl               hash(x::UInt64, h::UInt)
# hashing.jl               hash(x::Int64, h::UInt)
# hashing.jl               hash(x::Union{Bool, Int8, UInt8, Int16, UInt16, Int32, UInt32}, h::UInt)
# hashing.jl      function hash(x::Float64, h::UInt)
# hashing.jl               hash(x::Float32, h::UInt)
# hashing.jl      function hash(x::Float16, h::UInt)
# hashing.jl      function hash(x::Real, h::UInt)
# hashing.jl               hash(x::QuoteNode, h::UInt)
# hashing.jl               hash(x::PhiNode, h::UInt)
# hashing.jl               hash(x::PhiCNode, h::UInt)
# hashing.jl      function hash(x::Expr, h::UInt)
# hashing.jl      function hash(x::CodeInfo, h::UInt)
# hashing.jl      function hash(x::DebugInfo, h::UInt)
# hashing.jl               hash(x::GlobalRef, h::UInt)
# hashing.jl      function hash(x::PartialStruct, h::UInt)
# hashing.jl               hash(data::AbstractString, h::UInt)
# irrationals.jl           hash(x::Irrational, h::UInt)
# namedtuple.jl            hash(x::NamedTuple, h::UInt)
# pkgid.jl        function hash(pkg::PkgId, h::UInt)
# rational.jl     function hash(x::Rational{<:BitInteger64}, h::UInt)
# regex.jl        function hash(r::Regex, h::UInt)
# set.jl          function hash(s::AbstractSet, h::UInt)
# stacktraces.jl  function hash(frame::StackFrame, h::UInt)
# tuple.jl        function hash(t::Any32, h::UInt)

# operators.jl             isequal(x, y) = (x == y)::Bool
# operators.jl             in(x, itr::Any) = any(==(x), itr)
# operators.jl             identity(@nospecialize x) = x

# runtime_internals.jl function objectid(@nospecialize(x))

@test Core.:(===) === ===

end # module test_base_hashing
