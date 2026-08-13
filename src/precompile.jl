# module TestCompiler

using LogicalOperators: LogicalOperators
using JSON3: JSON3
using Dates: Dates

if VERSION >= v"1.12"
# TestCompiler.CompilerDevTools
#=    8.7 ms =# precompile(Tuple{typeof(TestCompiler.CompilerDevTools.lookup_method_instance), Function, Int64, Vararg{Int64}})

# TestCompiler.TraceEvents
#=   92.6 ms =# precompile(Tuple{Type{TestCompiler.TraceEvents.Timing}, JSON3.Array{JSON3.Object{S, TT} where TT<:AbstractArray{UInt64, 1} where S<:AbstractArray{UInt8, 1}, Base.CodeUnits{UInt8, String}, Base.SubArray{UInt64, 1, Array{UInt64, 1}, Tuple{Base.UnitRange{Int64}}, true}}, Dates.DateTime})
#=    5.3 ms =# precompile(Tuple{typeof(Base.getproperty), TestCompiler.TraceEvents.Timing, Symbol})
#=    3.8 ms =# precompile(Tuple{typeof(TestCompiler.TraceEvents.parse_tracefile), String})
end # if

# module TestCompiler
