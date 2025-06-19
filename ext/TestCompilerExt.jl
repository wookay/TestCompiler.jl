module TestCompilerExt

import TestCompiler: extension_interface

using Compiler
using Core: Compiler as CC

function extension_interface(::Symbol)
    (Compiler, CC)
end

end # module TestCompilerExt
