using Jive
@useinside Main module test_juliainterpreter_ExprSplitter

using Test
using JuliaInterpreter # ExprSplitter Frame
using Jive

ex = :( 1 + 2 )
sp = ExprSplitter(Main, ex)
@test sp.index == Int[]
@test sp.lnn === nothing
@test sp.stack == [(Main, :(1 + 2))]

for (mod, e) in sp
    frame = Frame(mod, e)
    if VERSION >= v"1.12-beta"
        @test sprint_plain(frame) == """
Frame for Main
  1*    1 ─ %1 = Main.:+
  2     │   %2 =   dynamic (%1)(1, 2)
  3     └──      return %2\
"""
    end
end

end # module test_juliainterpreter_ExprSplitter
