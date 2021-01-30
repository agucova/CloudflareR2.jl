module Minio

using AWS, AWSS3, URIs


struct MinioConfig{C} <: AbstractAWSConfig
    endpoint::URI
    region::String
    creds::C
end

function MinioConfig(endpoint::URI, region::AbstractString, creds=nothing)
    MinioConfig{typeof(creds)}(endpoint, region, creds)
end
function MinioConfig(endpoint::AbstractString, region::AbstractString, creds=nothing)
    MinioConfig(URI(endpoint), region, creds)
end

AWS.region(cfg::MinioConfig) = cfg.region
AWS.credentials(cfg::MinioConfig) = cfg.creds

function AWS.generate_service_url(cfg::MinioConfig, service::AbstractString, resource::AbstractString)
    service == "s3" || throw(ArgumentError("Minio config only supports S3 service requests; got $service"))
    joinpath(cfg.endpoint, resource)
end


export MinioConfig
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
