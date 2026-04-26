module test_base_namedtuple

using Test

# julia commit 4fdd12e277
# Specialize f in map(f, ::NamedTuple)

function ntmap1(f,    nt::NamedTuple{names}, nts::NamedTuple...) where {names}
    NamedTuple{names}(map(f, map(Tuple, (nt, nts...))...))
end

function ntmap2(f::F, nt::NamedTuple{names}, nts::NamedTuple...) where {names, F}
    NamedTuple{names}(map(f, map(Tuple, (nt, nts...))...))
end

a = (x1=[1.0], x2=[2.0], x3=[3.0], x4=[4.0], x5=[5.0], x6=[6.0], x7=[7.0], x8=[8.0], x9=[9.0], x10=[10.0], x11=[11.0])
b = map(copy, a)

function bench(f, a, b, N)
    s = 0
    for _ in 1:N; s += length(f(copyto!, a, b).x1); end; s
end

fs = (ntmap2, ntmap1)
table = Dict()
for f in fs
    bench(f, a, b, 1)
    t = @timed bench(f, a, b, 1_000_000)
    table[f] = t
end
@test table[ntmap1].time > table[ntmap2].time * 8

end # module test_base_namedtuple
