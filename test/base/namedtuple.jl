module test_base_namedtuple

using Test

# see also specialize.jl

# julia commit 4fdd12e277
# Specialize f in map(f, ::NamedTuple)

function ntmap1(f,    nt::NamedTuple{names}, nts::NamedTuple...) where {names}
    NamedTuple{names}(map(f, map(Tuple, (nt, nts...))...))
end

function ntmap2(f::F, nt::NamedTuple{names}, nts::NamedTuple...) where {names, F}
    NamedTuple{names}(map(f, map(Tuple, (nt, nts...))...))
end

function bench21(f, a, b, N)
    s = 0
    for _ in 1:N; s += length(f(copyto!, a, b).x1); end; s
end

a = (x1=[1.0], x2=[2.0], x3=[3.0], x4=[4.0], x5=[5.0], x6=[6.0], x7=[7.0], x8=[8.0], x9=[9.0], x10=[10.0], x11=[11.0])
b = map(copy, a)

fs = (ntmap2, ntmap1)
elapsed = Dict()
for f in fs
    bench21(f, a, b, 1)
    t = @timed bench21(f, a, b, 1_000_000)
    elapsed[f] = t
end

@test elapsed[ntmap2].time      <  elapsed[ntmap1].time
@test elapsed[ntmap2].time * 8  <  elapsed[ntmap1].time


function ntmap3(f,    nt::NamedTuple{names}, nts::NamedTuple...) where {names}
    map(f, map(Tuple, (nt, nts...))...)
end

function ntmap4(f::F, nt::NamedTuple{names}, nts::NamedTuple...) where {names, F}
    map(f, map(Tuple, (nt, nts...))...)
end

function bench43(f, a, b, N)
    s = 0
    for _ in 1:N; s += length(f(copyto!, a, b)); end; s
end

fs = (ntmap4, ntmap3)
elapsed = Dict()
for f in fs
    bench43(f, a, b, 1)
    t = @timed bench43(f, a, b, 1_000_000)
    elapsed[f] = t
end

@test elapsed[ntmap4].time      <  elapsed[ntmap3].time

end # module test_base_namedtuple
