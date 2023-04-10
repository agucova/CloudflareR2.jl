module CloudflareR2

using AWS, AWSS3, URIs

include("client.jl")

export R2Config
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
