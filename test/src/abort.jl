module test_src_abort

# from julia/src/stackwalk.c
#      julia/test/cmdlineargs.jl

using Test

exename = `$(Base.julia_cmd()) --startup-file=no --color=yes --compile=yes -g1`
script = :(
    @noinline abort_from_julia() = ccall(:abort, Cvoid, ());
    abort_from_julia()
)
errp = PipeBuffer()
p = run(pipeline(ignorestatus(`$exename -e $script`), stderr=errp))
err_s = read(errp, String)
@test Base.process_signaled(p) && p.termsignal == 6 # SIGABRT

if VERSION >= v"1.15-DEV"
               # signal 6: Aborted
               # signal 6 (-6): Aborted
@test occursin(r"signal 6.*: Aborted\nin expression starting at none:", err_s)
@test occursin("abort_from_julia at none:", err_s)
elseif VERSION >= v"1.11"
               # signal 6: Abort trap: 6
               # signal 6 (-6): Aborted
@test occursin(r"signal 6.*Abort.*\nin expression starting at none:", err_s)
@test occursin("abort_from_julia at ./none:", err_s)
end

end # module test_src_abort
