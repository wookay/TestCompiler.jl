using Jive
# julia commit 8808706c63
@If VERSION >= v"1.14.0-DEV.1630" module test_testcompiler_time_trace

using Test
using TestCompiler.TraceEvents
using Dates

# from julia/test/cmdlineargs.jl
function readchomperrors(exename::Cmd)
    out = Base.PipeEndpoint()
    err = Base.PipeEndpoint()
    p = run(exename, devnull, out, err, wait=false)
    o = @async(readchomp(out))
    e = @async(readchomp(err))
    return (success(p), fetch(o), fetch(e))
end

@testset "time-trace" begin
    exename = `$(Base.julia_cmd()) --startup-file=no --color=no`
    mktempdir() do dir
        tracefile = joinpath(dir, "test_trace.json")
        # Use forward slashes on Windows to avoid LLVM command line parser issues with backslashes
        tracefile_arg = Sys.iswindows() ? replace(tracefile, "\\" => "/") : tracefile
        v = readchomperrors(setenv(`$exename -e "1+1"`,
            "JULIA_LLVM_ARGS" => "-time-trace -time-trace-file=$tracefile_arg",
            "HOME" => homedir()))
        @test v[1]
        @test isfile(tracefile)
        time_trace = TraceEvents.parse_tracefile(tracefile)
        # @info time_trace
    end
end

# 1+1
content = """
{"traceEvents":[{"cat":"","pid":26673,"tid":259,"ts":0,"ph":"M","name":"process_name","args":{"name":"julia"}},{"cat":"","pid":26673,"tid":259,"ts":0,"ph":"M","name":"thread_name","args":{"name":""}}],"beginningOfTime":1769637957888468}
"""
time_trace = TraceEvents.parse_content(content)
@test time_trace.beginningOfTime == Dates.DateTime("2026-01-28T22:05:57.888")

# println(1+2)
tracefile = normpath(@__DIR__, "test_trace.json")
time_trace = TraceEvents.parse_tracefile(tracefile)
@test length(time_trace.traceEvents) == 161

end # module test_testcompiler_time_trace
