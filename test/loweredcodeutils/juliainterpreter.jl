using Jive # Jive v0.3.1
@useinside Main module test_loweredcodeutils_juliainterpreter

using Test
using LoweredCodeUtils.JuliaInterpreter # Frame

module A
end

mod = A
ex = :(1 + 2)
frame = Frame(mod, ex)

using Jive # sprint_plain

frame = Frame(mod, ex)
@test sprint_plain(frame) in (
#= julia 1.12 =# """
Frame for Main.A
  1*    1 ─ %1 = Main.A.:+
  2     │   %2 =   dynamic (%1)(1, 2)
  3     └──      return %2\
""",
#= julia 1.11 =# """
Frame for Main.A
  1* 0  1 ─ %1 = +
  2  0  │   %2 = (%1)(1, 2)
  3  0  └──      return %2\
""")

end # @useinside Main module test_loweredcodeutils_juliainterpreter
