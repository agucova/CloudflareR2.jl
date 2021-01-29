using Minio
using Documenter

DocMeta.setdocmeta!(Minio, :DocTestSetup, :(using Minio); recursive=true)

makedocs(;
    modules=[Minio],
    authors="Expanding Man <savastio@protonmail.com> and contributors",
    repo="https://gitlab.com/ExpandingMan/Minio.jl/blob/{commit}{path}#{line}",
    sitename="Minio.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ExpandingMan.gitlab.io/Minio.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
