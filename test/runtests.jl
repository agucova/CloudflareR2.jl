using Minio
using Test

# NOTE: the vast majority of min.io functionality is in AWSS3, which is why these tests are so minimal

# these get passed to the server
ENV["MINIO_ACCESS_KEY"] = "testuser"
ENV["MINIO_SECRET_KEY"] = "testpassword"

# these should be picked up by MinioConfig
ENV["AWS_ACCESS_KEY_ID"] = "testuser"
ENV["AWS_SECRET_ACCESS_KEY"] = "testpassword"

# for some reason minio freaks out if you give it an absolute path it doesn't like
tmp = mktempdir(".")

s = Minio.Server(tmp)
run(s, wait=false)

@testset "Minio.jl" begin
    @test process_running(s)

    # with explicit config
    cfg = MinioConfig("http://localhost:9000",
                      username="testuser", password="testpassword")

    s3_create_bucket(cfg, "testbucket")

    buck = S3Path("s3://testbucket/", config=cfg)
    path = joinpath(buck, "testfile.txt")

    teststr = "this is a test\n"

    write(path, teststr)

    @test readdir(buck) == ["testfile.txt"]
    @test String(read(path)) == teststr

    # config from environment
    cfg = MinioConfig("http://localhost:9000")
    buck = S3Path("s3://testbucket/", config=cfg)
    path = joinpath(buck, "testfile.txt")
    @test readdir(buck) == ["testfile.txt"]
    @test String(read(path)) == teststr

    rm(path, recursive=true, force=true)

    @test readdir(buck) == []
end

try
    kill(s)
finally
    isdir(tmp) && rm(tmp, recursive=true, force=true)
end
