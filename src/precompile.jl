# module TestCompiler

using LogicalOperators: LogicalOperators
using JSON3: JSON3
using Dates: Dates

if VERSION >= v"1.12"
# TestCompiler.CompilerDevTools
#=    8.7 ms =# precompile(Tuple{typeof(TestCompiler.CompilerDevTools.lookup_method_instance), Function, Int64, Vararg{Int64}})

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
