# module TestCompiler

using LogicalOperators: LogicalOperators
using JSON3: JSON3
using Dates: Dates

if VERSION >= v"1.12"
# TestCompiler.CompilerDevTools
#=    8.7 ms =# precompile(Tuple{typeof(TestCompiler.CompilerDevTools.lookup_method_instance), Function, Int64, Vararg{Int64}})

# TestCompiler.EffectBits
#=    3.1 ms =# precompile(Tuple{typeof(Base.:(+)), TestCompiler.EffectBits.EffectSuffix})
#=   14.3 ms =# precompile(Tuple{typeof(Base.in), TestCompiler.EffectBits.EffectLetter, Base.Compiler.Effects})
#=    3.4 ms =# precompile(Tuple{typeof(Base.:(!)), TestCompiler.EffectBits.EffectSuffix})
#=  132.7 ms =# precompile(Tuple{Type{Base.Compiler.Effects}, Vararg{TestCompiler.EffectBits.EffectLetter, 9}})
#=   36.1 ms =# precompile(Tuple{Type{Base.Compiler.Effects}, Vararg{TestCompiler.EffectBits.EffectLetter, 8}})
#=   27.8 ms =# precompile(Tuple{Type{Base.Compiler.Effects}, TestCompiler.EffectBits.EffectLetter})
#=    3.0 ms =# precompile(Tuple{typeof(Base.:(var"==")), TestCompiler.EffectBits.EffectSuffix, TestCompiler.EffectBits.EffectSuffix})
#=    3.3 ms =# precompile(Tuple{typeof(Base.:(~)), TestCompiler.EffectBits.EffectSuffix})
#=    2.9 ms =# precompile(Tuple{Type{TestCompiler.EffectBits.EffectLetter}, Char, Char})
#=    3.5 ms =# precompile(Tuple{typeof(Base.:(var"==")), TestCompiler.EffectBits.EffectLetter, TestCompiler.EffectBits.EffectLetter})
#=    6.2 ms =# precompile(Tuple{typeof(TestCompiler.EffectBits.effects_field_name), TestCompiler.EffectBits.EffectSuffix})
#=    6.7 ms =# precompile(Tuple{typeof(TestCompiler.EffectBits.effects_field_name), TestCompiler.EffectBits.EffectLetter})
#=    6.6 ms =# precompile(Tuple{typeof(TestCompiler.EffectBits.effects_suffix), Symbol})
#=  188.0 ms =# precompile(Tuple{Type{Base.Compiler.Effects}, Vararg{TestCompiler.EffectBits.EffectLetter, 4}})
#=    8.7 ms =# precompile(Tuple{typeof(TestCompiler.EffectBits.effect_bits), typeof(Base.Compiler.is_effect_free_if_inaccessiblememonly)})
#=    6.1 ms =# precompile(Tuple{Type{LogicalOperators.AND{T} where T}, TestCompiler.EffectBits.EffectLetter})
#=   20.4 ms =# precompile(Tuple{typeof(Base.:(var"==")), LogicalOperators.AND{TestCompiler.EffectBits.EffectLetter}, LogicalOperators.AND{TestCompiler.EffectBits.EffectLetter}})
#=   20.5 ms =# precompile(Tuple{typeof(Base.:(var"==")), Array{TestCompiler.EffectBits.EffectLetter, 1}, Array{TestCompiler.EffectBits.EffectLetter, 1}})
#=    6.1 ms =# precompile(Tuple{typeof(TestCompiler.EffectBits.effect_bits), typeof(Base.Compiler.is_inaccessiblemem_or_argmemonly)})
#=    6.1 ms =# precompile(Tuple{typeof(TestCompiler.EffectBits.effect_bits), typeof(Base.Compiler.is_consistent_overlay)})
#=   17.9 ms =# precompile(Tuple{typeof(TestCompiler.EffectBits.detect), Function, Base.Compiler.Effects})
#=   20.0 ms =# precompile(Tuple{typeof(TestCompiler.EffectBits.effect_bits), typeof(Base.Compiler.is_foldable)})
#=    6.9 ms =# precompile(Tuple{Type{LogicalOperators.OR{T} where T}, TestCompiler.EffectBits.EffectLetter, Vararg{TestCompiler.EffectBits.EffectLetter}})
#=    8.6 ms =# precompile(Tuple{typeof(Base.collect), Type{TestCompiler.EffectBits.EffectLetter}, Tuple{TestCompiler.EffectBits.EffectLetter, TestCompiler.EffectBits.EffectLetter}})
#=   20.6 ms =# precompile(Tuple{typeof(Base.collect), Type{Union{Bool, TestCompiler.EffectBits.EffectLetter}}, Tuple{Bool, TestCompiler.EffectBits.EffectLetter}})
#=    8.2 ms =# precompile(Tuple{Type{LogicalOperators.AND{T} where T}, TestCompiler.EffectBits.EffectLetter, Vararg{Any}})
#=   30.4 ms =# precompile(Tuple{typeof(Base.collect), Type{Union{TestCompiler.EffectBits.EffectLetter, LogicalOperators.OR{TestCompiler.EffectBits.EffectLetter}, LogicalOperators.OR{Union{Bool, TestCompiler.EffectBits.EffectLetter}}}}, Tuple{TestCompiler.EffectBits.EffectLetter, LogicalOperators.OR{TestCompiler.EffectBits.EffectLetter}, TestCompiler.EffectBits.EffectLetter, TestCompiler.EffectBits.EffectLetter, LogicalOperators.OR{Union{Bool, TestCompiler.EffectBits.EffectLetter}}}})
#=  125.6 ms =# precompile(Tuple{typeof(TestCompiler.EffectBits.detect_cause), LogicalOperators.AND{Union{TestCompiler.EffectBits.EffectLetter, LogicalOperators.OR{TestCompiler.EffectBits.EffectLetter}, LogicalOperators.OR{Union{Bool, TestCompiler.EffectBits.EffectLetter}}}}, Base.Compiler.Effects})
#=    5.7 ms =# precompile(Tuple{typeof(Base.getindex), Array{Union{TestCompiler.EffectBits.EffectLetter, LogicalOperators.OR{TestCompiler.EffectBits.EffectLetter}, LogicalOperators.OR{Union{Bool, TestCompiler.EffectBits.EffectLetter}}}, 1}, Int64})
#=    3.1 ms =# precompile(Tuple{typeof(Base.getindex), Array{TestCompiler.EffectBits.EffectLetter, 1}, Int64})
#=    3.7 ms =# precompile(Tuple{typeof(Base.last), Array{TestCompiler.EffectBits.EffectLetter, 1}})
#=    5.6 ms =# precompile(Tuple{typeof(Base.getindex), Array{Union{Bool, TestCompiler.EffectBits.EffectLetter}, 1}, Int64})
#=    5.6 ms =# precompile(Tuple{typeof(Base.last), Array{Union{Bool, TestCompiler.EffectBits.EffectLetter}, 1}})
#=    2.6 ms =# precompile(Tuple{typeof(Base.Iterators.enumerate), LogicalOperators.AND{Union{TestCompiler.EffectBits.EffectLetter, LogicalOperators.OR{TestCompiler.EffectBits.EffectLetter}, LogicalOperators.OR{Union{Bool, TestCompiler.EffectBits.EffectLetter}}}}})
#=    1.9 ms =# precompile(Tuple{typeof(Base.iterate), LogicalOperators.AND{Union{TestCompiler.EffectBits.EffectLetter, LogicalOperators.OR{TestCompiler.EffectBits.EffectLetter}, LogicalOperators.OR{Union{Bool, TestCompiler.EffectBits.EffectLetter}}}}})
#=    9.1 ms =# precompile(Tuple{typeof(Base.show), Base.GenericIOBuffer{Memory{UInt8}}, Base.Multimedia.MIME{:var"text/plain"}, LogicalOperators.OR{TestCompiler.EffectBits.EffectLetter}})
#=    3.3 ms =# precompile(Tuple{typeof(Base.Iterators.enumerate), Array{TestCompiler.EffectBits.EffectLetter, 1}})
#=    9.5 ms =# precompile(Tuple{typeof(Base.show), Base.GenericIOBuffer{Memory{UInt8}}, Base.Multimedia.MIME{:var"text/plain"}, LogicalOperators.OR{Union{Bool, TestCompiler.EffectBits.EffectLetter}}})
#=    3.5 ms =# precompile(Tuple{typeof(Base.Iterators.enumerate), Array{Union{Bool, TestCompiler.EffectBits.EffectLetter}, 1}})
#=    4.5 ms =# precompile(Tuple{typeof(Base.collect), Type{TestCompiler.EffectBits.EffectLetter}, Tuple{TestCompiler.EffectBits.EffectLetter}})
#=    8.5 ms =# precompile(Tuple{typeof(Base.getindex), Array{Tuple{Int64, Union{TestCompiler.EffectBits.EffectLetter, LogicalOperators.OR{T} where T}}, 1}, Int64})
#=    5.4 ms =# precompile(Tuple{typeof(Base.indexed_iterate), Tuple{Int64, TestCompiler.EffectBits.EffectLetter}, Int64})
#=    4.7 ms =# precompile(Tuple{typeof(Base.indexed_iterate), Tuple{Int64, TestCompiler.EffectBits.EffectLetter}, Int64, Int64})
#=    3.5 ms =# precompile(Tuple{Type{TestCompiler.EffectBits.EffectLetter}, UInt8, Char})
#=    7.4 ms =# precompile(Tuple{typeof(TestCompiler.EffectBits.effect_bits), typeof(Base.Compiler.is_consistent_if_notreturned)})
#=   76.6 ms =# precompile(Tuple{typeof(TestCompiler.EffectBits.detect_cause), LogicalOperators.AND{TestCompiler.EffectBits.EffectLetter}, Base.Compiler.Effects})
#=    2.4 ms =# precompile(Tuple{typeof(Base.Iterators.enumerate), LogicalOperators.AND{TestCompiler.EffectBits.EffectLetter}})
#=    1.9 ms =# precompile(Tuple{typeof(Base.iterate), LogicalOperators.AND{TestCompiler.EffectBits.EffectLetter}})

# TestCompiler.PartitionKinds
#=    2.6 ms =# precompile(Tuple{typeof(Base.:(var"==")), TestCompiler.PartitionKinds.PartitionKind, TestCompiler.PartitionKinds.PartitionKind})
#=   12.3 ms =# precompile(Tuple{typeof(Base.string), TestCompiler.PartitionKinds.PartitionKind})
#=    5.2 ms =# precompile(Tuple{typeof(TestCompiler.PartitionKinds.kinds), typeof(Base.is_defined_const_binding)})
#=    6.1 ms =# precompile(Tuple{typeof(Base.:(var"==")), NTuple{4, TestCompiler.PartitionKinds.PartitionKind}, NTuple{4, TestCompiler.PartitionKinds.PartitionKind}})
#=    5.8 ms =# precompile(Tuple{typeof(TestCompiler.PartitionKinds.kinds), typeof(Base.is_some_const_binding)})
#=    5.7 ms =# precompile(Tuple{typeof(Base.:(var"==")), NTuple{5, TestCompiler.PartitionKinds.PartitionKind}, NTuple{5, TestCompiler.PartitionKinds.PartitionKind}})
#=    6.3 ms =# precompile(Tuple{typeof(TestCompiler.PartitionKinds.kinds), typeof(Base.is_some_imported)})
#=    5.3 ms =# precompile(Tuple{typeof(TestCompiler.PartitionKinds.kinds), typeof(Base.is_some_explicit_imported)})
#=    5.6 ms =# precompile(Tuple{typeof(TestCompiler.PartitionKinds.kinds), typeof(Base.is_some_implicit)})
#=    3.7 ms =# precompile(Tuple{typeof(Base.:(var"==")), Tuple{TestCompiler.PartitionKinds.PartitionKind, TestCompiler.PartitionKinds.PartitionKind}, Tuple{TestCompiler.PartitionKinds.PartitionKind, TestCompiler.PartitionKinds.PartitionKind}})
#=    5.1 ms =# precompile(Tuple{typeof(TestCompiler.PartitionKinds.kinds), typeof(Base.is_some_binding_imported)})
#=    4.4 ms =# precompile(Tuple{typeof(Base.:(var"==")), Tuple{TestCompiler.PartitionKinds.PartitionKind, TestCompiler.PartitionKinds.PartitionKind, TestCompiler.PartitionKinds.PartitionKind}, Tuple{TestCompiler.PartitionKinds.PartitionKind, TestCompiler.PartitionKinds.PartitionKind, TestCompiler.PartitionKinds.PartitionKind}})
#=    5.8 ms =# precompile(Tuple{typeof(TestCompiler.PartitionKinds.kinds), typeof(Base.is_some_guard)})
#=    3.4 ms =# precompile(Tuple{Type{UInt8}, TestCompiler.PartitionKinds.Enums.PARTITION_KIND})
#=    8.5 ms =# precompile(Tuple{typeof(Base.in), TestCompiler.PartitionKinds.PartitionKind, NTuple{4, TestCompiler.PartitionKinds.PartitionKind}})
#=    6.8 ms =# precompile(Tuple{typeof(Base.in), TestCompiler.PartitionKinds.PartitionKind, NTuple{5, TestCompiler.PartitionKinds.PartitionKind}})
#=    5.0 ms =# precompile(Tuple{typeof(Base.in), TestCompiler.PartitionKinds.PartitionKind, Tuple{TestCompiler.PartitionKinds.PartitionKind, TestCompiler.PartitionKinds.PartitionKind}})
#=    5.4 ms =# precompile(Tuple{typeof(Base.in), TestCompiler.PartitionKinds.PartitionKind, Tuple{TestCompiler.PartitionKinds.PartitionKind, TestCompiler.PartitionKinds.PartitionKind, TestCompiler.PartitionKinds.PartitionKind}})

# TestCompiler.TraceEvents
#=   92.6 ms =# precompile(Tuple{Type{TestCompiler.TraceEvents.Timing}, JSON3.Array{JSON3.Object{S, TT} where TT<:AbstractArray{UInt64, 1} where S<:AbstractArray{UInt8, 1}, Base.CodeUnits{UInt8, String}, Base.SubArray{UInt64, 1, Array{UInt64, 1}, Tuple{Base.UnitRange{Int64}}, true}}, Dates.DateTime})
#=    5.3 ms =# precompile(Tuple{typeof(Base.getproperty), TestCompiler.TraceEvents.Timing, Symbol})
#=    3.8 ms =# precompile(Tuple{typeof(TestCompiler.TraceEvents.parse_tracefile), String})

# Base.Compiler
#=    5.0 ms =# precompile(Tuple{typeof(Base.:(var"==")), Base.Compiler.Effects, Base.Compiler.Effects})
end # if

# module TestCompiler
