module test_stdlibs_pkg

using Test
using Pkg
using UUIDs

# REPL
@test Pkg.Types.is_stdlib(UUID("3fa0cd96-eef1-5676-8a61-b3b8758bbffb"), VERSION)

end # module test_stdlibs_pkg
