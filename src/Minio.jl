module Minio

using AWS, AWSS3, URIs
using Base: Process

const MINIO_EXE = Ref{String}("")

# TODO set up to fetch binary as artifact during build if not already installed
function getexe()
    io, err = IOBuffer(), IOBuffer()
    run(pipeline(Cmd(`which minio`, ignorestatus=true), stdout=io, stderr=err))
    exe = chomp(String(take!(io)))
    ispath(exe) ? exe : ""
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
