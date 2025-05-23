# module TestCompiler.EffectBits

using Core: Compiler as CC
using Base.Docs: Binding
using Base.IRShow: effectbits_letter
import REPL: summarize

# from julia/stdlib/REPL/src/docview.jl
function summarize(io::IO, effects::CC.Effects, binding::Binding)
    println(io, "# Summary")
    TT = CC.Effects
    T = Base.unwrap_unionall(TT)
    if T isa DataType
        println(io, "```")
        print(io,
            Base.isabstracttype(T) ? "abstract type " :
            Base.ismutabletype(T)  ? "mutable struct " :
            Base.isstructtype(T) ? "struct " :
            "primitive type ")
        supert = supertype(T)
        println(io, T)
        println(io, "```")
        if !Base.isabstracttype(T) && T.name !== Tuple.name && !isempty(fieldnames(T))
            println(io, "# Fields")
            println(io, "```")
            pad_effect = 0
            pad = 0
            for f in fieldnames(T)
                effect = getfield(effects, f)
                pad_effect = max(pad_effect, length(string(
                    if effect isa Bool
                        effect
                    elseif effect isa UInt8
                        effect_bits_const_name(f, effect)
                    else
                        nothing
                    end
                )))
                pad = max(pad, length(string(f)))
            end
            for (f, t) in zip(fieldnames(T), fieldtypes(T))
                suffix::Char = effects_suffix(f)
                letter = effectbits_letter(effects, f, suffix)
                print(io, letter)
                print(io, " ")
                effect = getfield(effects, f)
                if t === Bool
                    print(io, rpad(effect, pad_effect))
                else
                    const_name = effect_bits_const_name(f, effect)
                    print(io, rpad(const_name, pad_effect))
                end
                print(io, " ")
                println(io, rpad(f, pad), " :: ", t)
            end
            println(io, "```")
        end
    end
end

# module TestCompiler.EffectBits
