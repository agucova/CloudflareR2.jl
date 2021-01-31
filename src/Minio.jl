module Minio

using AWS, AWSS3, URIs, Pkg.Artifacts
using Base: Process

const MINIO_EXE = Ref{String}("")


"""
    getexe()

Get the path of the min.io binary executable.  If minio is not already installed, this package will
fetch it as a binary artifact during its build step.

The downloaded artifact will be used by default, if available.

The build step of this package will always update the binary artifact to the latest version of min.io.  This will
be skipped only if a system min.io installation (discoverable via `which minio`) is found.
"""
function getexe()
    toml = joinpath(@__DIR__,"..","Artifacts.toml")
    arthash = artifact_hash("minio", toml)
    if isnothing(arthash)
        io, err = IOBuffer(), IOBuffer()
        run(pipeline(Cmd(`which minio`, ignorestatus=true), stdout=io, stderr=err))
        exe = chomp(String(take!(io)))
        ispath(exe) ? exe : ""
    else
        joinpath(artifact_path(arthash), "minio")
    end
end

__init__() = (MINIO_EXE[] = getexe())


include("client.jl")
include("server.jl")


MinioConfig(s::Server; kwargs...) = MinioConfig(s.address; kwargs...)


export MinioConfig
export AWSCredentials
# exports from AWSS3.jl
export S3Path, s3_arn, s3_put, s3_get, s3_get_file, s3_exists, s3_delete, s3_copy,
       s3_create_bucket,
       s3_put_cors,
       s3_enable_versioning, s3_delete_bucket, s3_list_buckets,
       s3_list_objects, s3_list_keys, s3_list_versions,
       s3_get_meta, s3_purge_versions,
       s3_sign_url, s3_begin_multipart_upload, s3_upload_part,
       s3_complete_multipart_upload, s3_multipart_upload,
       s3_get_tags, s3_put_tags, s3_delete_tags

end
