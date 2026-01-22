module TestCompilerExt

import TestCompiler: extension_interface

using Compiler: Compiler as C
using Core: Compiler as CC

function extension_interface()
    (C, CC)
end

end # module TestCompilerExt
