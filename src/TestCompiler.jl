module TestCompiler

include("CompilerDevTools.jl")
include("PartitionKinds.jl")
include("EffectBits/EffectBits.jl")
include("extension-interface.jl")
include("TraceEvents.jl")
include("SysImage.jl")
Base.generating_output() && include("precompile.jl")

end # module TestCompiler
