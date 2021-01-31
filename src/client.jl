
"""
    MinioConfig

A configuration object allowing the AWS S3 interface from AWS.jl and AWSS3.jl for min.io.

## Constructors
```julia
MinioConfig(endpoint, creds; region="")
MinioConfig(endpoint; region="", username, password, token="", user_arn="")
```

## Arguments
- `endpoint`: The URL of the min.io server as either a `String` or a `URI`.
- `creds`: An `AWSCredentials` object providing the credentials to access the min.io server.
- `region`: The region string. This is AWS functionality and not likely to be relevant for min.io.
- `username`: A username with which to access the min.io server. This will use `AWS_ACCESS_KEY_ID` if
    available, otherwise default to `"minioadmin"`.
- `password`: A password with which to access the min.io server. This will use `AWS_SECRET_ACCESS_KEY`
    if available, otherwise default to `"minioadmin"`.
- `token`: Token to provide to the server.
- `user_arn`: A user ARN string to provide to the server.

## Examples
```julia
using Minio

cfg = MinioConfig("http://localhost:9000")

# using the AWS S3 API
s3_list_buckets(cfg)

# using the S3Path interface
path = S3Path("s3://bucket-name", config=cfg)
readdir(path)
```
"""
struct MinioConfig <: AbstractAWSConfig
    endpoint::URI
    region::String
    creds::AWSCredentials
end

function MinioConfig(endpoint::URI, creds::AWSCredentials; region::AbstractString="")
    MinioConfig(endpoint, region, creds)
end
function MinioConfig(endpoint::AbstractString, creds::AWSCredentials; region::AbstractString="")
    MinioConfig(URI(endpoint), creds; region)
end
function MinioConfig(endpoint::Union{URI,AbstractString}; region::AbstractString="",
                     username::AbstractString=get(ENV, "AWS_ACCESS_KEY_ID", "minioadmin"),
                     password::AbstractString=get(ENV, "AWS_SECRET_ACCESS_KEY", "minioadmin"),
                     token::AbstractString="", user_arn::AbstractString="")
    MinioConfig(endpoint, AWSCredentials(username, password, token, user_arn); region)
end

AWS.region(cfg::MinioConfig) = cfg.region
AWS.credentials(cfg::MinioConfig) = cfg.creds

function AWS.generate_service_url(cfg::MinioConfig, service::String, resource::String)
    service == "s3" || throw(ArgumentError("Minio config only supports S3 service requests; got $service"))
    string(joinpath(cfg.endpoint, resource))
end

