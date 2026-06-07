module RuntimeInternals # TestCompiler

# from julia/base/runtime_internals.jl

if VERSION >= v"1.14.0-DEV.2291" # julia commit 26145852c4
using Base: type_parameter
end


function _uniontypes(@nospecialize(x), ts::Vector{Type})
    if x isa Union
        _uniontypes(x.a, ts)
        _uniontypes(x.b, ts)
    else
        push!(ts, x)
    end
    return ts
end
uniontypes(@nospecialize(x)) = _uniontypes(x, Type[])

end # module TestCompiler.RuntimeInternals
