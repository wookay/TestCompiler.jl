module test_base_libc

using Test

# from julia/test/testhelpers/withlocales.jl
function withlocales(f, newlocales)
    # save current locales
    locales = Dict{Int,String}()
    for cat in 0:9999
        cstr = ccall(:setlocale, Cstring, (Cint, Cstring), cat, C_NULL)
        if cstr != C_NULL
            locales[cat] = unsafe_string(cstr)
        end
    end
    try
        # change to each of the given locales
        for lc in newlocales
            set = true
            for (cat, _) in locales
                set &= ccall(:setlocale, Cstring, (Cint, Cstring), cat, lc) != C_NULL
            end
            set && f(lc)
        end
    finally
        # recover locales
        for (cat, lc) in locales
            cstr = ccall(:setlocale, Cstring, (Cint, Cstring), cat, lc)
        end
    end
end

# from julia/test/misc.jl
withlocales(["ko_KR.UTF-8"]) do locale
    @test Libc.strftime(0.0)                    == "목  1/ 1 09:00:00 1970"
    @test Libc.strftime("%a %A %b %B %p %Z", 0) == "목 목요일  1 1월 AM KST"
end

withlocales(["ja_JP.UTF-8"]) do locale
    @test Libc.strftime(0.0)                    == "木  1/ 1 09:00:00 1970"
end


function save_current_locales()
    # save current locales
    locales = Dict{Int,String}()
    for cat in 0:9999
        cstr = ccall(:setlocale, Cstring, (Cint, Cstring), cat, C_NULL)
        if cstr != C_NULL
            locales[cat] = unsafe_string(cstr)
        end
    end
    return locales
end

function recover(locales)
    # recover locales
    for (cat, lc) in locales
        cstr = ccall(:setlocale, Cstring, (Cint, Cstring), cat, lc)
    end
end

function withlocale(f, lc)
    cat = 0
    set = ccall(:setlocale, Cstring, (Cint, Cstring), cat, lc) != C_NULL
    set && f()
end

locales = save_current_locales()

withlocale("ko_KR.UTF-8") do
    @test Libc.strftime(0.0) == "목  1/ 1 09:00:00 1970"
end

withlocale("ja_JP.UTF-8") do
    @test Libc.strftime(0.0) == "木  1/ 1 09:00:00 1970"
end

recover(locales)

end # module test_base_libc
