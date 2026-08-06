module TestCompiler

include("RuntimeInternals.jl")
include("CompilerDevTools.jl")
include("PartitionKinds.jl")
include("extension-interface.jl")
include("TraceEvents.jl")
Base.generating_output() && include("precompile.jl")

end # module TestCompiler
