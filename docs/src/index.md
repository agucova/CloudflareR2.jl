```@meta
CurrentModule = CloudflareR2
```

# CloudflareR2
!!! note

    This package is a fork from [Minio.jl](https://gitlab.com/ExpandingMan/Minio.jl).
    This is also not an official Cloudflare package.

This package provides Julia tools for working with [Cloudflare R2](https://www.cloudflare.com/products/r2/).  Cloudflare R2 is fully compatible with the AWS S3
interface, so interaction with R2 is achieved through
[AWSS3.jl](https://github.com/JuliaCloud/AWSS3.jl).  This package simply contains some
convenient constructors to set up the configuration to be used with AWSS3.jl.

## Installation
The package itself can be installed with

```julia
Pkg.add("CloudflareR2")
```
or `]add CloudflareR2` in the REPL.

## Client
This package provides a `AbstractAWSConfig` object to be used with Cloudflare R2. This allows seamless integration with the AWSS3.jl package.

```@docs
CloudflareR2.R2Config
```
