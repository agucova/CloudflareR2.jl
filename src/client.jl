
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

