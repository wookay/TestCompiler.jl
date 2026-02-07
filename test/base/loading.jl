module test_base_loading

# from julia/base/loading.jl
#
# see also TestStdlibs/test/pkg/loading.jl

using Test

if VERSION >= v"1.11"
Base.track_nested_precomp # function
    Base.precompilation_stack # ::Vector{Base.PkgId}
Base.loading_extension # ::Bool
Base.loadable_extensions # ::Union{Nothing,Vector{PkgId}}
Base.precompiling_extension # ::Bool
Base.include_package_for_output # function
    Base.__toplevel__ # baremodule
  # Base.newly_inferred # ::Vector{Core.CodeInstance}

# Extensions #
Base.EXT_PRIMED # ::Dict{PkgId,Vector{PkgId}}
Base.EXT_DORMITORY # ::Dict{PkgId,Vector{ExtensionId}}
Base.EXT_DORMITORY_FAILED # ::Vector{ExtensionId}
Base.insert_extension_triggers # function
Base.run_package_callbacks # function
Base.retry_load_extensions # function

Base.isprecompiled # function
Base.isrelocatable # function

Base.pkgorigins # ::Dict{PkgId,PkgOrigin}
Base.loaded_modules # ::Dict{PkgId,Module}
Base.loaded_precompiles # ::Dict{PkgId,Vector{Module}}
Base.loaded_modules_order # ::Vector{Module}()


pkgid = Base.identify_package(Test, "Test")
if isempty(Base.precompilation_stack)
    pkgs = [pkgid]
    Base.track_nested_precomp(pkgs)
    @test Base.precompilation_stack == pkgs
end
@test endswith(Base.compilecache_dir(pkgid), string(VERSION.major, ".", VERSION.minor, "/Test"))
@test Base.isprecompiled(pkgid; ignore_loaded = true)

### Base.isrelocatable
@test Base.isrelocatable(pkgid) # Return whether a given PkgId within the active project is precompiled
                                # and the associated cache is relocatable.
freshest_path = Base.compilecache_freshest_path(pkgid)
open(freshest_path, "r") do io
    @test !iszero(Base.isvalid_cache_header(io))
    # mutable struct Base.CacheHeaderIncludes
    # id       :: Base.PkgId
    # filename :: String
    # fsize    :: UInt64
    # hash     :: UInt32
    # mtime    :: Float64
    # modpath  :: Vector{String}
    _, (includes, includes_srcfiles, _), _... = Base._parse_cache_header(io, freshest_path)
    @test Set(map(x -> x.filename, includes)) == includes_srcfiles
end

@test Base.loading_extension === false
@test Base.loadable_extensions === nothing
@test Base.precompiling_extension === false
if VERSION >= v"1.14.0-DEV.1303" # julia commit 3484331cb1
    @test names(Base.__toplevel__, all = true) == [Symbol("#_internal_julia_parse"),
                                                   :__toplevel__,
                                                   :_internal_julia_lower,
                                                   :_internal_syntax_version]
else
    @test names(Base.__toplevel__, all = true) == [:__toplevel__]
end
if VERSION >= v"1.12.0-DEV.1400" # julia commit b7b79eb8f6
    @test Base.newly_inferred == Core.CodeInstance[]
end
@test Base.EXT_PRIMED isa Dict
@test Base.EXT_DORMITORY isa Dict
@test Base.EXT_DORMITORY_FAILED == Base.ExtensionId[]
@test Base.pkgorigins isa Dict
@test Base.loaded_modules isa Dict
@test Base.loaded_precompiles isa Dict
@test Module[Core, Base, Main] == Base.loaded_modules_order[1:3]
end # if


#=
const PRECOMPILE_TRACE_COMPILE = Ref{String}()
function create_expr_cache(pkg::PkgId, input::PkgLoadSpec, output::String, output_o::Union{Nothing, String},
                           concrete_deps::typeof(_concrete_dependencies), flags::Cmd=``, cacheflags::CacheFlags=CacheFlags(),
                           internal_stderr::IO = stderr, internal_stdout::IO = stdout, loadable_exts::Union{Vector{PkgId},Nothing}=nothing)

        empty!(Base.EXT_DORMITORY) # If we have a custom sysimage with `EXT_DORMITORY` prepopulated
        Base.track_nested_precomp($(_pkg_str(vcat(Base.precompilation_stack, pkg))))
        Base.loadable_extensions = $(_pkg_str(loadable_exts))
        Base.precompiling_extension = $(loading_extension)
        Base.include_package_for_output($(_pkg_str(pkg)), $(repr(abspath(input.path))), $(repr(input.julia_syntax_version)), $(repr(depot_path)), $(repr(dl_load_path)),
            $(repr(load_path)), $(_pkg_str(concrete_deps)), $(repr(source_path(nothing))))
=#

end # module test_base_loading
