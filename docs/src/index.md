```@meta
CurrentModule = Minio
```

# Minio
This package provides Julia tools for working with the [min.io](https://min.io) data
storage program.  Min.io is an open source tool fully compatible with the AWS S3
interface, so interaction with a min.io service is achieved through
[AWSS3.jl](https://github.com/JuliaCloud/AWSS3.jl).  This package simply contains some
convenient constructors for a configuration allowing min.io to be used with AWSS3.jl, as
well as some simple terms for managing min.io servers.

## Installation
The package itself can be installed with
```julia
Pkg.add("Minio")
```
or `]add Minio` in the REPL.

During this package's build step, it checks whether a `minio` binary is available (it
determines this using `which minio`).  If no `minio` binary is found, the latest version
will be downloaded using Julia's Pkg artifacts system.  This binary will be accessible
via `Minio.Server` (see below).  This installation can be incredibly useful for testing:
you can test your package that uses min.io/S3 in CI/CD with no special handling or extra
steps.  If you want to use the `minio` binary via the command line, you should install it
as normal, please see the [min.io download page](https://min.io/download).

!!! note

    If you are using the `minio` binary via Julia artifacts, you can update it to the
    latest version at any time by building the package with `Pkg.build("Minio")` or
    `]build Minio` in the REPL.


## Client
This package provides a `AbstractAWSConfig` object appropraite for use with a min.io
service.
```@docs
Minio.MinioConfig
```

## Server
This package provides some convenient tools for managing a min.io server from Julia.
```@docs
Minio.Server
```
