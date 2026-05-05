module test_base_cmd

using Test

# from julia/base/cmd.jl

Base.byteenv
Base.setenv
Base.splitenv
Base.addenv

if VERSION >= v"1.14.0-DEV.2014" # julia commit 9b03f4ae1b
Base.show_env

io = IOBuffer()
for show_env in (:all, :none, :keys, :_unset)
    ioc = IOContext(io, :show_env => show_env)
    mode = Base.get_show_env_mode(ioc)
    if show_env === :_unset
        envval = get(ENV, "JULIA_SHOW_ENV", nothing)
        if envval === nothing
            @test mode === :redact
        end
    else
        @test mode === show_env
    end
end # for
end # if

end # module test_base_cmd
