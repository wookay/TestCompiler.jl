using Jive
@If VERSION >= v"1.14-DEV" module test_testcompiler_helpmode

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
reset_safe          :: UInt8
nothrow             :: Bool
terminates          :: Bool
notaskstate         :: Bool
inaccessiblememonly :: UInt8
noub                :: UInt8
nonoverlayed        :: UInt8
nortcall            :: Bool\
"""
end # if !haskey(Base.loaded_modules, pkg)

end # module test_testcompiler_helpmode
