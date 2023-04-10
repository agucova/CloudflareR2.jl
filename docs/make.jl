using CloudflareR2
using Documenter

DocMeta.setdocmeta!(CloudflareR2, :DocTestSetup, :(using CloudflareR2); recursive=true)

makedocs(;
    modules=[CloudflareR2],
    authors="Agustín Covarrubias",
    repo="https://github.com/agucova/R2.jl/blob/{commit}{path}#{line}",
    sitename="CloudflareR2.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://agucova.github.io/R2.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/agucova/R2.jl",
    devbranch="main",
)
