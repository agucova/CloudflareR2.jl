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

!!! note

    This package is unofficial. It does not link to any min.io library, but rather calls
    a separate min.io process, either through a shell or HTTP.
    If you are a min.io maintainer and are interested in moving this package to an
    official repository, please open an issue.

## Installation
The package itself can be installed with
```julia
Pkg.add("Minio")
```
or `]add Minio` in the REPL.

Minio.jl uses [`minio_jll`](https://github.com/JuliaBinaryWrappers/minio_jll.jl) to provide the
minio binary.

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
