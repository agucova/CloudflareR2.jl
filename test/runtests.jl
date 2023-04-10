using R2
using Test
using URIs

# NOTE: the vast majority of min.io functionality is in AWSS3, which is why these tests are so minimal

# these should be picked up by R2Config
ENV["R2_ACCESS_KEY_ID"] = "testuser"
ENV["R2_SECRET_ACCESS_KEY"] = "testpassword"

@testset "R2.jl" begin
    cfg = R2Config("ACCOUNTID")
    @test cfg.region == "auto"
    @test cfg.endpoint == URI("https://ACCOUNTID.r2.cloudflarestorage.com")

    # Test invalid account id
    @test_throws ArgumentError R2Config("non_alpha")

    # Custom endpoint
    cfg = R2Config(URI("http://localhost:9000"))
    @test cfg.region == "auto"

    # With credentials
    cfg = R2Config(URI("http://localhost:9000"),
                       access_key_id="test", secret_access_key="test")
    @test cfg.region == "auto"
    @test cfg.endpoint == URI("http://localhost:9000")

    # Test invalid region
    @test_throws ArgumentError R2Config(URI("http://localhost:9000"), cfg.creds; region="invalid")
end
