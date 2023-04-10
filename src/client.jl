
"""
    R2Config

A configuration object allowing to use the AWS S3 interface from AWS.jl and AWSS3.jl with [Cloudflare R2](https://developers.cloudflare.com/r2/). You can generate your access key ID and secret access key from the [R2 dashboard](https://developers.cloudflare.com/r2/api/s3/tokens/), as well as your account ID from the [Cloudflare dashboard](https://developers.cloudflare.com/fundamentals/get-started/basic-tasks/find-account-and-zone-ids/).

## Constructors
```julia
# By passing only your Cloudflare account ID
R2Config(account_id; access_key_id, secret_access_key)
R2Config(account_id, creds)

# By passing the endpoint directly
using URIs

R2Config(URI(endpoint); access_key_id, secret_access_key)
R2Config(URI(endpoint), creds)
```

## Arguments
- `account_id`: Your [Cloudflare account ID](https://developers.cloudflare.com/fundamentals/get-started/basic-tasks/find-account-and-zone-ids/). This will be used to construct the endpoint URL.
- `endpoint`: Your Cloudflare S3 API endpoint.
- `creds`: An `AWSCredentials` object providing the credentials to access R2.
- `access_key_id`: An access key ID for Cloudflare R2. This will use `R2_ACCESS_KEY_ID` or `AWS_ACCESS_KEY_ID` if
    available, or otherwise set to an empty string.
- `secret_access_key`: A secret access key for Cloudflare R2. This will use `R2_SECRET_ACCESS_KEY` or `AWS_SECRET_ACCESS_KEY`
    if available, or otherwise set to an empty string.

## Examples
```julia
using R2

cfg = R2Config("YOUR_ACCOUNT_ID")

# using the AWS S3 API
s3_list_buckets(cfg)

# using the S3Path interface
path = S3Path("s3://bucket-name", config=cfg)
readdir(path)
```
"""

struct R2Config <: AbstractAWSConfig
    endpoint::URI
    region::String
    creds::AWSCredentials
end

function R2Config(endpoint::URI, creds::AWSCredentials)
    R2Config(endpoint, "cloudflare-global", creds)
end

function isalnum(s::AbstractString)::Bool
    for c in s
        isletter(c) || isdigit(c) || return false
    end
    return true
end

function R2Config(account_id::AbstractString, creds::AWSCredentials)
    if !isalnum(account_id)
        throw(ArgumentError("account_id must be alphanumeric. \
        If you want to pass the endpoint directly, pass a URI object instead."))
    end
    endpoint = URI("https://$(account_id).r2.cloudflarestorage.com")
    R2Config(URI(endpoint), creds)
end

function get_access_key_id()
    return @something get(ENV, "R2_ACCESS_KEY_ID", missing), get(ENV, "AWS_ACCESS_KEY_ID", "")
end

function get_secret_access_key()
    return @something get(ENV, "R2_SECRET_ACCESS_KEY", missing), get(ENV, "AWS_SECRET_ACCESS_KEY", "")
end

function R2Config(
        id_or_endpoint::Union{AbstractString, URI};
        access_key_id::AbstractString=get_access_key_id(),
        secret_access_key::AbstractString=get_secret_access_key(),
    )
    R2Config(id_or_endpoint, AWSCredentials(access_key_id, secret_access_key, "", ""))
end

AWS.region(cfg::R2Config) = cfg.region
AWS.credentials(cfg::R2Config) = cfg.creds

function AWS.generate_service_url(cfg::R2Config, service::String, resource::String)
    service == "s3" || throw(ArgumentError("An R2 config only supports S3 service requests; got $service"))
    # NOTE: cannot use joinpath here, as it will silently truncate many resource strings
    string(cfg.endpoint, resource)
end
