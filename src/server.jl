
const DEFAULT_ADDRESS = "localhost:9000"


"""
    Server

A data structure for managing a min.io server process.  By default, running this will execute the min.io binary as identified
during the initialization of the `Minio` module.

## Constructors
```julia
Server(cmd, addr::URI; detach=false)
Server(exe, dirs; detach=false, address="localhost:9000", certs_dir="", quiet=false, anonymous=false, json=false)
Server(dirs; detach=false, address="localhost:9000", certs_dir="", quiet=false, anonymous=false, json=false)
```

## Arguments
- `cmd::AbstractVector{<:AbstractString}`: The command executed when running the server as a `Vector` of strings.
- `exe::AbstractString`: The min.io executable to use.
- `dirs`: The directory or directories to host with the server, as they would be provided to the `minio server` command.
- `detach::Bool`: Whether or not to run the server process detached from the Julia process. Setting this to `true` allows
    the server process to outlive the Julia process which spawned it.
- `address`: Specifies the address and port of the server. Can be passed as it would be to the `minio server` command or as
    a full `http` or `https` URL.
- `certs_dir`: Path to certification directory. If empty, will use `minio` default.
- `quiet::Bool`: Run in quiet mode, with no information or logging output.
- `aononymous::Bool`: Hide sensitive information from logging.
- `json::Bool`: Whether to output logs and startup information as JSON.

## Examples
```julia
s = Minio.Server(".", address="localhost:9001")  # create a server which views the current directory

# start the server. if `wait=false`, it will be run asynchronously.
run(s, wait=false)

kill(s)  # kill the running server. will not work if `detach=true` as in this case Julia loses control of the child process
```
"""
mutable struct Server
    cmd::Cmd
    address::URI
    process::Process

    function Server(cmd::AbstractVector{<:AbstractString}, addr::URI; detach::Bool=false)
        new(Cmd(Cmd(cmd), detach=detach, env=ENV), addr)
    end
end

function Base.show(io::IO, s::Server)
    show(io, Server)
    print(io, "(\"", s.address, "\"")
    if isdefined(s, :process) && process_running(s.process)
        print(io, ", ")
        printstyled(io, "running", color=:green, bold=true)
    elseif isdefined(s, :process) && process_exited(s.process)
        print(io, ", ")
        printstyled(io, "exited", color=:magenta, bold=true)
    else
        print(io, ", uninitialized")
    end
    print(io, ")")
end

function _check_initialized(f, s::Server, args...; kwargs...)
    isdefined(s, :process) ? f(s, args...; kwargs...) : error("invalid operation on uninitialized server object $s")
end

Base.kill(s::Server) = _check_initialized(s -> kill(s.process), s)
Base.getpid(s::Server) = _check_initialized(s -> getpid(s.process), s)
Base.process_exited(s::Server) = _check_initialized(s -> process_exited(s.process), s)
Base.process_running(s::Server) = _check_initialized(s -> process_running(s.process), s)

server_uri(str::AbstractString) = startswith(str, r".*://") ? URI(str) : URI("http://"*str)

server_uri_arg(uri::URI) = uri.host * ":" * uri.port
server_uri_arg(s::Server) = server_uri_arg(s.address)

"""
    servercmd

Construct the command for running a min.io server as a `Vector` of strings.
"""
function servercmd(exe::AbstractString, dirs::AbstractVector{<:AbstractString}; address::AbstractString=DEFAULT_ADDRESS,
                   certs_dir::AbstractString="", quiet::Bool=false, anonymous::Bool=false, json::Bool=false)
    cmd  = String[exe; "server"; "--address"; address]
    isempty(certs_dir) || append!(cmd, ["--certs-dir", certs_dir])
    quiet && push!(cmd, "--quiet")
    anonymous && push!(cmd, "--anonymous")
    json && push!(cmd, "--json")
    append!(cmd, dirs)
    cmd
end

function Server(exe::AbstractString, dirs::AbstractVector{<:AbstractString}; address::AbstractString=DEFAULT_ADDRESS,
                detach::Bool=false, kwargs...)
    Server(servercmd(exe, dirs; address, kwargs...), server_uri(address); detach)
end
Server(dirs::AbstractVector{<:AbstractString}; kwargs...) = Server(MINIO_EXE[], dirs; kwargs...)
Server(dir::AbstractString; kwargs...) = Server([dir]; kwargs...)

function Base.run(s::Server; wait::Bool=true)
    s.process = run(s.cmd; wait)
    @info("Minio server started")
    s
end

