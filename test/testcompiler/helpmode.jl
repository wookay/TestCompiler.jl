module test_testcompiler_helpmode

using Test
using REPL
using Markdown

function helpmode(input::String)::Tuple{String, Markdown.MD}
    io = IOBuffer()
    md = eval(REPL.helpmode(io, input, @__MODULE__))
    buf = take!(io)
    search = String(buf)
    (search, md)
end

using Core: Compiler as CC

pkg = Base.PkgId(Base.UUID("a627c61c-6c20-4001-b596-bf51b2370e84"), "TestCompiler")
if !haskey(Base.loaded_modules, pkg)
(search, md) = helpmode("CC.EFFECTS_THROWS")
@test isempty(search)
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
end # if !haskey(Base.loaded_modules, pkg)

using TestCompiler.EffectBits

(search, md) = helpmode("CC.EFFECTS_THROWS")
@test isempty(search)
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

using .CC: Effects, CONSISTENT_IF_NOTRETURNED
effects = Effects(; consistent = CONSISTENT_IF_NOTRETURNED)

(search, md) = helpmode("effects")
@test search == "search: effects effect_bits EffectBits effects_suffix\n\n"
@test last(md.content).code == """
?c CONSISTENT_IF_NOTRETURNED consistent          :: UInt8
!e ALWAYS_FALSE              effect_free         :: UInt8
!n false                     nothrow             :: Bool
!t false                     terminates          :: Bool
!s false                     notaskstate         :: Bool
!m ALWAYS_FALSE              inaccessiblememonly :: UInt8
!u ALWAYS_FALSE              noub                :: UInt8
!o ALWAYS_FALSE              nonoverlayed        :: UInt8
!r false                     nortcall            :: Bool\
"""

end # module test_testcompiler_helpmode
