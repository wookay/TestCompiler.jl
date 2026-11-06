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


using Jive
@If VERSION >= v"1.15.0-DEV.503" module test_base_initdefs_sysimage_init
# julia commit e1aa66fded

# function __init_build()
Base._atexit_hooks_finished
Base.init_build_rng
Sys.__init_build
Base.reinit_stdio
Base.init_depot_path
Base.init_load_path
Base.init_active_project
Base.init_debuginfo_source_paths
Base.init_frontend

# function __uninit_build()
Base.uninit_toml_cache
Base.uninit_exec_options
Base.uninit_args
Base.uninit_frontend
Base.uninit_debuginfo_source_paths
Base.uninit_active_project
Base.uninit_load_path
Base.uninit_depot_path
Base.uninit_stdio
Sys.__uninit_build

end # module test_base_initdefs_sysimage_init
