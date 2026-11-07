module test_base_stream

using Test

# from julia/base/stream.jl
#      julia/test/read.jl

function test_const_isdefined(mod::Module, q::Expr)
    for x in q.args
        x isa LineNumberNode && continue
        (sym, val) = x.args[1].args
        @test getglobal(mod, sym) == val
    end
end

test_const_isdefined(Base, quote
const StatusUninit      = 0 # handle is allocated, but not initialized
const StatusInit        = 1 # handle is valid, but not connected/active
const StatusConnecting  = 2 # handle is in process of connecting
const StatusOpen        = 3 # handle is usable
const StatusActive      = 4 # handle is listening for read/write/connect events
const StatusClosing     = 5 # handle is closing / being closed
const StatusClosed      = 6 # handle is closed
const StatusEOF         = 7 # handle is a TTY that has seen an EOF event (pretends to be closed until reseteof is called)
const StatusPaused      = 8 # handle is Active, but not consuming events, and will transition to Open if it receives an event
end)

Base.uv_status_string

# IO
# +- GenericIOBuffer{T<:AbstractVector{UInt8}} (not exported)
# +- AbstractPipe (not exported)
# .  +- Pipe
# .  +- Process (not exported)
# .  +- ProcessChain (not exported)
# +- DevNull (not exported)
# +- Filesystem.File
# +- LibuvStream (not exported)
# .  +- PipeEndpoint (not exported)
# .  +- TCPSocket
# .  +- TTY (not exported)
# .  +- UDPSocket
# .  +- BufferStream (FIXME: 2.0)
# +- IOBuffer = Base.GenericIOBuffer{Vector{UInt8}}
# +- IOStream

# IOServer
# +- LibuvServer
# .  +- PipeServer
# .  +- TCPServer

# Redirectable = Union{IO, FileRedirect, Libc.RawFD} (not exported)

using Base: IO, GenericIOBuffer, AbstractPipe, Pipe, Process, ProcessChain, DevNull, LibuvStream, PipeEndpoint, TTY, BufferStream, IOBuffer, IOStream
using Base: Filesystem
using Base: IOServer, LibuvServer
using Sockets: TCPSocket, UDPSocket, PipeServer, TCPServer

@test IO >: GenericIOBuffer
@test IO >: AbstractPipe >: Pipe
@test IO >: AbstractPipe >: Process
@test IO >: AbstractPipe >: ProcessChain
@test IO >: DevNull
@test IO >: Filesystem.File
@test IO >: LibuvStream >: PipeEndpoint
@test IO >: LibuvStream >: TCPSocket
@test IO >: LibuvStream >: TTY
@test IO >: LibuvStream >: UDPSocket
@test IO >: LibuvStream >: BufferStream
@test IO >: IOBuffer
@test IO >: IOStream

@test IOServer >: LibuvServer >: PipeServer
@test IOServer >: LibuvServer >: TCPServer

if VERSION >= v"1.15.0-DEV.556" # julia commit 3a168ef581
writepartial
end

end # module test_base_stream
