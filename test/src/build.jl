# Makefile
# Make.inc

#=
MAKE = make
QUIET_MAKE = -s
BUILDROOT = .

julia_flisp.boot.inc.phony: julia-deps
    @$(MAKE) $(QUIET_MAKE) -C $(BUILDROOT)/src julia_flisp.boot.inc.phony

julia $ make -C ./src julia_flisp.boot.inc.phony
make: Nothing to be done for `julia_flisp.boot.inc.phony'.
=#


#=
JL_PRIVATE_LIBS-0 += libjulia-internal libjulia-codegen
=#


# sysimage.mk


#=
    CC src/jltypes.o
    CC src/gf.o
    CC src/typemap.o
    CC src/smallintset.o
    CC src/ast.o
    CC src/builtins.o
    CC src/module.o
    CC src/interpreter.o
    CC src/symbol.o
    CC src/dlload.o
    CC src/sys.o
    CC src/init.o
    CC src/task.o
    CC src/array.o
    CC src/genericmemory.o
    CC src/staticdata.o
    CC src/toplevel.o
    CC src/jl_uv.o
    CC src/datatype.o
    CC src/simplevector.o
    CC src/runtime_intrinsics.o
    CC src/precompile.o
    CC src/jloptions.o
    CC src/mtarraylist.o
    CC src/threading.o
    CC src/scheduler.o
    CC src/stackwalk.o
    CC src/null_sysimage.o
    CC src/method.o
    CC src/jlapi.o
    CC src/signal-handling.o
    CC src/safepoint.o
    CC src/timing.o
    CC src/subtype.o
    CC src/rtutils.o
    CC src/crc32c.o
    CC src/APInt-C.o
    CC src/processor.o
    CC src/ircode.o
    CC src/opaque_closure.o
    CC src/codegen-stubs.o
    CC src/coverage.o
    CC src/runtime_ccall.o
    CC src/engine.o
    CC src/gc-common.o
    CC src/gc-stacks.o
    CC src/gc-alloc-profiler.o
    CC src/gc-heap-snapshot.o
    CC src/gc-stock.o
    CC src/gc-debug.o
    CC src/gc-pages.o
    CC src/gc-page-profiler.o
    LINK usr/lib/libjulia-internal.dylib
=#


#=
    CC src/codegen.o
    CC src/jitlayers.o
    CC src/aotcompile.o
    CC src/debuginfo.o
    CC src/disasm.o
    CC src/llvm-simdloop.o
    CC src/llvm-pass-helpers.o
    CC src/llvm-ptls.o
    CC src/llvm-propagate-addrspaces.o
    CC src/llvm-multiversioning.o
    CC src/llvm-alloc-opt.o
    CC src/llvm-alloc-helpers.o
    CC src/cgmemmgr.o
    CC src/llvm-remove-addrspaces.o
    CC src/llvm-remove-ni.o
    CC src/llvm-julia-licm.o
    CC src/llvm-demote-float16.o
    CC src/llvm-cpufeatures.o
    CC src/llvm-expand-atomic-modify.o
    CC src/pipeline.o
    CC src/llvm_api.o
    CC src/llvm-final-gc-lowering.o
    CC src/llvm-late-gc-lowering.o
    CC src/llvm-gc-invariant-verifier.o
    CC src/llvm-final-gc-lowering-stock.o
    LINK usr/lib/libjulia-codegen.dylib
=#


#=
    LINK usr/lib/julia/basecompiler.dylib
=#


#=
    LINK usr/lib/julia/sysbase.dylib
=#


#=
    LINK usr/lib/julia/sys.dylib
=#
