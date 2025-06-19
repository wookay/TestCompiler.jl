module test_revise_track

# don't test Revise on CI

using Revise
Revise.track(Base)

using Test
@test true

end # module test_revise_track
