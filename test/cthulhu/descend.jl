module test_cthulhu_descend

using Test
using Cthulhu

# Cthulhu/test/FakeTerminals.jl
fake_terminals_path = normpath(pathof(Cthulhu), "../../test/FakeTerminals.jl")
include(fake_terminals_path) # 1 test
using .FakeTerminals

# Cthulhu/test/test_terminal.jl
cread1(io) = readuntil(io, '↩'; keep=true)
cread(io) = cread1(io) * cread1(io)

const keydict = Dict(:up => "\e[A",
                     :down => "\e[B",
                     :enter => '\r')

fake_terminal() do term, in, out, _
    t = @async begin
        @descend terminal=term sin(1)
    end
    lines = cread(out)
    # print(lines)
    #=
sin(x::Real) @ Base.Math math.jl:1528
1528 function ($f)(x::Int64::Real)::Float64
1529         xf::Float64 = float(x::Int64)::Float64
1530         (xf::Float64 isa typeof(x::Int64)::Type{Int64})::Core.Const(false) && throw(MethodError($f, (x,)))
1531         return ($f)(xf::Float64)::Float64
1532     end
Select a call to descend into or ↩ to ascend. [q]uit. [b]ookmark.
Toggles: [w]arn, [h]ide type-stable statements, [t]ype annotations, [s]yntax highlight for Source/LLVM/Native, [j]ump to source always.
Show: [S]ource code, [A]ST, [T]yped code, [L]LVM IR, [N]ative code
Actions: [E]dit source code, [R]evise and redisplay
 • float(x::Int64)
   ($f)(xf::Float64)
   ↩ =#
    @test occursin("Base.Math", lines)

    # write(in, keydict[:enter])
    # lines = cread(out)
    # print(lines)

    write(in, 'q')
    wait(t)
end

end # module test_cthulhu_descend
