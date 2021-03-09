using Pkg.Artifacts
#using Downloads: download  # this is for 1.6; will still work but with a warning otherwise

function minio_executable_name()
    if Sys.iswindows()
        "minio.exe"
    else
        "minio"
    end
end

function minio_download_url()
    arch = if Sys.islinux()
        "linux-amd64"
    elseif Sys.isapple()
        "darwin-amd64"
    elseif Sys.iswindows()
        "windows-amd64"
    elseif Sys.isbsd()
        error("Hi Alex, thanks for installing my package, but I don't think min.io provides BSD binaries")
    else
        error("what the hell operating system is this?")
    end
    exec = minio_executable_name()
    "https://dl.min.io/server/minio/release/$arch/$exec"
end

toml = joinpath(@__DIR__,"..","Artifacts.toml")

minio = artifact_hash("minio", toml)

if !Sys.iswindows() && success(`which minio`)
    path = readchomp(`which minio`)
    @info("existing minio binaries found at $path")
else
    # we do this so that the build step always updates the binary unless a system minio is installed
    isnothing(minio) || artifact_exists(minio) && remove_artifact(minio)
    isfile(toml) && unbind_artifact!(toml, "minio")

    minio = create_artifact() do dir
        url = minio_download_url()
        @info("downloading minio binary from $url")
        download(url, joinpath(dir,minio_executable_name()))
    end

    bind_artifact!(toml, "minio", minio)
    exe = joinpath(artifact_path(minio),minio_executable_name())
    chmod(exe, 0o777)
    @info("minio binary installed at $exe")
end
