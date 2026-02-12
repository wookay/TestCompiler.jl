#=
juila $ make
    FLISP src/julia_flisp.boot
    FLISP src/julia_flisp.boot.inc
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
    LINK usr/lib/libjulia-internal.1.14.0.dylib
ld: warning: ignoring duplicate libraries: '-lzstd'
    LINK usr/lib/libjulia-internal.1.14.dylib
    LINK usr/lib/libjulia-internal.dylib
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
    LINK usr/lib/libjulia-codegen.1.14.0.dylib
    LINK usr/lib/libjulia-codegen.1.14.dylib
    LINK usr/lib/libjulia-codegen.dylib
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   477  100   477    0     0    108      0  0:00:04  0:00:04 --:--:--   123
100  699k  100  699k    0     0   114k      0  0:00:06  0:00:06 --:--:--  953k
mkdir -p julia/usr/share/julia/juliac/
julia/contrib/install.sh 755 julia/contrib/juliac/juliac.jl julia/usr/share/julia/juliac/
/bin/sh: line 1: 10443 Abort trap: 6           julia/usr/tools/libwhich -p libcrypto.dylib 2> /dev/null
/bin/sh: line 1: 10445 Abort trap: 6           julia/usr/tools/libwhich -p libssl.dylib 2> /dev/null
    PERL base/version_git.jl.phony
    JULIA usr/lib/julia/basecompiler-o.a
coreio.jl
exports.jl
docs/core.jl
public.jl
essentials.jl
ctypes.jl
gcutils.jl
generator.jl
runtime_internals.jl
options.jl
promotion.jl
tuple.jl
expr.jl
pair.jl
traits.jl
range.jl
error.jl
bool.jl
number.jl
int.jl
operators.jl
pointer.jl
refvalue.jl
cmem.jl
rounding.jl
float.jl
strings/lazy.jl
checked.jl
indices.jl
genericmemory.jl
array.jl
abstractarray.jl
baseext.jl
c.jl
abstractset.jl
bitarray.jl
bitset.jl
abstractdict.jl
iddict.jl
idset.jl
ntuple.jl
iterators.jl
namedtuple.jl
anyall.jl
ordering.jl
coreir.jl
module.jl
../usr/share/julia/Compiler/src/Compiler.jl
../usr/share/julia/Compiler/src/timing.jl
../usr/share/julia/Compiler/src/sort.jl
../usr/share/julia/Compiler/src/cicache.jl
../usr/share/julia/Compiler/src/methodtable.jl
../usr/share/julia/Compiler/src/effects.jl
../usr/share/julia/Compiler/src/types.jl
../usr/share/julia/Compiler/src/utilities.jl
../usr/share/julia/Compiler/src/validation.jl
../usr/share/julia/Compiler/src/ssair/basicblock.jl
../usr/share/julia/Compiler/src/ssair/domtree.jl
../usr/share/julia/Compiler/src/ssair/ir.jl
../usr/share/julia/Compiler/src/ssair/tarjan.jl
../usr/share/julia/Compiler/src/abstractlattice.jl
../usr/share/julia/Compiler/src/stmtinfo.jl
../usr/share/julia/Compiler/src/inferenceresult.jl
../usr/share/julia/Compiler/src/inferencestate.jl
../usr/share/julia/Compiler/src/typeutils.jl
../usr/share/julia/Compiler/src/typelimits.jl
../usr/share/julia/Compiler/src/typelattice.jl
../usr/share/julia/Compiler/src/tfuncs.jl
../usr/share/julia/Compiler/src/abstractinterpretation.jl
../usr/share/julia/Compiler/src/typeinfer.jl
../usr/share/julia/Compiler/src/optimize.jl
../usr/share/julia/Compiler/src/ssair/heap.jl
../usr/share/julia/Compiler/src/ssair/slot2ssa.jl
../usr/share/julia/Compiler/src/ssair/inlining.jl
../usr/share/julia/Compiler/src/ssair/verify.jl
../usr/share/julia/Compiler/src/ssair/legacy.jl
../usr/share/julia/Compiler/src/ssair/EscapeAnalysis.jl
../usr/share/julia/Compiler/src/ssair/disjoint_set.jl
../usr/share/julia/Compiler/src/ssair/passes.jl
../usr/share/julia/Compiler/src/ssair/irinterp.jl
../usr/share/julia/Compiler/src/bootstrap.jl
../usr/share/julia/Compiler/src/precompile.jl
../usr/share/julia/Compiler/src/reflection_interface.jl
../usr/share/julia/Compiler/src/opaque_closure.jl
../usr/share/julia/Compiler/src/reinfer.jl
../usr/share/julia/Compiler/src/bindinginvalidations.jl
Compiling the compiler. This may take several minutes ...
Base.Compiler ──── 420.79057502746582 seconds
flfrontend.jl
    LINK usr/lib/julia/basecompiler.dylib
ld: warning: reexported library with install name '@rpath/libunwind.1.dylib' found at 'julia/usr/lib/libunwind.dylib' couldn't be matched with any parent library and will be linked directly
warning: no debug symbols in executable (-arch x86_64)
    JULIA usr/lib/julia/sysbase-o.a
Base.jl
reflection.jl
refpointer.jl
./build_h.jl
./version_git.jl
meta.jl
multimedia.jl
char.jl
strings/basic.jl
strings/string.jl
strings/substring.jl
strings/cstring.jl
cartesian.jl
hashing.jl
osutils.jl
subarray.jl
views.jl
div.jl
twiceprecision.jl
complex.jl
rational.jl
multinverses.jl
abstractarraymath.jl
arraymath.jl
slicearray.jl
simdloop.jl
reduce.jl
reshapedarray.jl
reinterpretarray.jl
some.jl
dict.jl
hamt.jl
set.jl
io.jl
iobuffer.jl
linked_list.jl
condition.jl
threads.jl
threadingconstructs.jl
locks-mt.jl
lock.jl
intfuncs.jl
strings/strings.jl
strings/annotated.jl
strings/search.jl
strings/unicode.jl
strings/util.jl
strings/io.jl
strings/annotated_io.jl
regex.jl
pcre.jl
./pcre_h.jl
parse.jl
shell.jl
stacktraces.jl
show.jl
../usr/share/julia/Compiler/src/ssair/show.jl
../usr/share/julia/Compiler/src/verifytrim.jl
arrayshow.jl
methodshow.jl
multidimensional.jl
broadcast.jl
missing.jl
version.jl
sysinfo.jl
libc.jl
./errno_h.jl
libdl.jl
atomics.jl
channels.jl
partr.jl
task.jl
threads_overloads.jl
weakkeydict.jl
scopedvalues.jl
logging/logging.jl
logging/ConsoleLogger.jl
env.jl
libuv.jl
./uv_constants.jl
asyncevent.jl
iostream.jl
stream.jl
filesystem.jl
path.jl
stat.jl
file.jl
./file_constants.jl
cmd.jl
process.jl
terminfo.jl
terminfo_data.jl
Terminals.jl
secretbuffer.jl
floatfuncs.jl
math.jl
special/cbrt.jl
special/exp.jl
special/hyperbolic.jl
special/trig.jl
special/rem_pio2.jl
special/rem2pi.jl
special/log.jl
special/pow.jl
reducedim.jl
accumulate.jl
permuteddimsarray.jl
sort.jl
fastmath.jl
Enums.jl
gmp.jl
ryu/Ryu.jl
ryu/utils.jl
ryu/shortest.jl
ryu/fixed.jl
ryu/exp.jl
mpfr.jl
rawbigfloats.jl
combinatorics.jl
irrationals.jl
mathconstants.jl
experimental.jl
opaque_closure.jl
deepcopy.jl
download.jl
summarysize.jl
errorshow.jl
util.jl
initdefs.jl
threadcall.jl
uuid.jl
pkgid.jl
toml_parser.jl
linking.jl
loading.jl
binaryplatforms.jl
cpuid.jl
features_h.jl
timing.jl
client.jl
asyncmap.jl
deprecated.jl
docs/basedocs.jl
docs/intrinsicsdocs.jl
docs/Docs.jl
docs/bindings.jl
docs/utils.jl
precompilation.jl
JuliaSyntax/src/JuliaSyntax.jl
Base  ────────── 36.329082 seconds
FileWatching  ──  4.697991 seconds
Libdl  ─────────  0.002471 seconds
Artifacts  ─────  0.263986 seconds
SHA  ───────────  0.272159 seconds
Sockets  ───────  0.904686 seconds
LinearAlgebra  ─  7.208544 seconds
Random  ────────  1.492371 seconds
Stdlibs total  ─ 14.846454 seconds
Sysimage built. Summary:
Base ────────  36.329082 seconds 70.989%
Stdlibs ─────  14.846454 seconds 29.0108%
Total ───────  51.175626 seconds
    LINK usr/lib/julia/sysbase.dylib
ld: warning: reexported library with install name '@rpath/libunwind.1.dylib' found at 'julia/usr/lib/libunwind.dylib' couldn't be matched with any parent library and will be linked directly
    JULIA usr/lib/julia/sys-o.a
Collecting and executing precompile statements
└ Collect (Basic: ✓ 232) => Execute ✓ 326
Precompilation complete. Summary:
Total ───────   8.078768 seconds
Outputting sysimage file...
Output ──────  91.953236 seconds
    LINK usr/lib/julia/sys.dylib
ld: warning: reexported library with install name '@rpath/libunwind.1.dylib' found at 'julia/usr/lib/libunwind.dylib' couldn't be matched with any parent library and will be linked directly
    CC usr/lib/libllvmcalltest.dylib
ld: warning: reexported library with install name '@rpath/libunwind.1.dylib' found at 'julia/usr/lib/libunwind.dylib' couldn't be matched with any parent library and will be linked directly
    JULIA stdlib/release.image
Precompiling for 2 compilation configurations...
Precompiling packages  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╸━━━━━━━━━━ 80/108
Precompiling packages finished.
  108 dependency configurations successfully precompiled in 171 seconds
=#
