module test_base_initdefs

# from julia/base/initdefs.jl

using Test
using Pkg

Base.PROGRAM_FILE
Base.ARGS
Base.exit
@test Base.roottask isa Task
Base.isinteractive

# ENV JULIA_DEPOT_PATH
Base.DEPOT_PATH

# ENV JULIA_LOAD_PATH
Base.DEFAULT_LOAD_PATH
Base.load_path
    # from julia/base/loading.jl
    Base.LoadingCache
    Base.LOADING_CACHE
  Base.LOAD_PATH

# ENV JULIA_PROJECT
Base.HOME_PROJECT
Base.current_project
Base.active_project
  Base.ACTIVE_PROJECT
Base.set_active_project

if VERSION >= v"1.13.0-DEV.1377" # julia commit a5c6ddb1f6
Base.active_manifest
end # if
Base.atexit

## postoutput: register post output hooks ##
## like atexit but runs after any requested output.
## any hooks saved in the sysimage are cleared in Base._start
Base.postoutput
@test Base.postoutput_hooks isa Vector{Base.Callable}

# from julia/base/client.jl
Base._start
  # empty!(ARGS)
  # append!(ARGS, Core.ARGS)
  # clear any postoutput hooks that were saved in the sysimage
  # empty!(Base.postoutput_hooks)
  # ...


if isdir(DEPOT_PATH[1])
    @test Pkg.devdir() == joinpath(DEPOT_PATH[1], "dev")
end

end # module test_base_initdefs
