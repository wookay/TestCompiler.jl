module test_testcompiler_helpmode

using Test
using REPL
using Markdown

function helpmode(input::String)::Markdown.MD
    io = IOBuffer()
    md = eval(REPL.helpmode(io, input, @__MODULE__))
    seekstart(io)
    @assert isempty(take!(io))
    md
end

using Core: Compiler as CC

md = helpmode("CC.EFFECTS_THROWS")
@test last(md.content).code == """
consistent          :: UInt8
effect_free         :: UInt8
nothrow             :: Bool
terminates          :: Bool
notaskstate         :: Bool
inaccessiblememonly :: UInt8
noub                :: UInt8
nonoverlayed        :: UInt8
nortcall            :: Bool\
"""

using TestCompiler.EffectBits

md = helpmode("CC.EFFECTS_THROWS")
@test last(md.content).code == """
+c ALWAYS_TRUE consistent          :: UInt8
+e ALWAYS_TRUE effect_free         :: UInt8
!n false       nothrow             :: Bool
+t true        terminates          :: Bool
+s true        notaskstate         :: Bool
+m ALWAYS_TRUE inaccessiblememonly :: UInt8
+u ALWAYS_TRUE noub                :: UInt8
+o ALWAYS_TRUE nonoverlayed        :: UInt8
+r true        nortcall            :: Bool\
"""

end # module test_testcompiler_helpmode
