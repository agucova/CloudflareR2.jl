using Minio
using Test

# NOTE: the vast majority of min.io functionality is in AWSS3, which is why these tests are so minimal

# these get passed to the server
ENV["MINIO_ACCESS_KEY"] = "testuser"
ENV["MINIO_SECRET_KEY"] = "testpassword"

# these should be picked up by MinioConfig
ENV["AWS_ACCESS_KEY_ID"] = "testuser"
ENV["AWS_SECRET_ACCESS_KEY"] = "testpassword"


s = Minio.Server(@__DIR__)
run(s, wait=false)

@testset "Minio.jl" begin
    @test process_running(s)

    # with explicit config
    cfg = MinioConfig("http://localhost:9000",
                      username="testuser", password="testpassword")
    path = S3Path("s3://testbucket", config=cfg)
    @test readdir(path) == ["testfile.txt"]
    @test String(read(joinpath(path, "testfile.txt"))) == "this is a test\n"

    # config from environment
    cfg = MinioConfig("http://localhost:9000")
    path = S3Path("s3://testbucket", config=cfg)
    @test readdir(path) == ["testfile.txt"]
    @test String(read(joinpath(path, "testfile.txt"))) == "this is a test\n"
end

kill(s)
