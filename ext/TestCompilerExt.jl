module TestCompilerExt

import Compiler: hello_ext

function hello_ext(::Int)
    42
end

end # module TestCompilerExt
