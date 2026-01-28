module TraceEvents # TestCompiler.TraceEvents

using Dates
using JSON3

json_decode = JSON3.read
json_encode = JSON3.write

struct Timing
    traceEvents::Vector
    beginningOfTime::DateTime
end

function parse_content(content::String)::Timing
    profile = json_decode(content)
    traceEvents = profile["traceEvents"]
    beginningOfTime = unix2datetime(profile["beginningOfTime"] / 1000 / 1000)
    Timing(traceEvents, beginningOfTime)
end

function parse_tracefile(tracefile::String)::Timing
    content = read(tracefile, String)
    parse_content(content)
end

end # module TestCompiler.TraceEvents
