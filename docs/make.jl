using Documenter, GrandGameOfLife

makedocs(;
    modules=[GrandGameOfLife],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/Arkoniak/GrandGameOfLife.jl/blob/{commit}{path}#L{line}",
    sitename="GrandGameOfLife.jl",
    authors="Andrey Oskin",
    assets=String[],
)

deploydocs(;
    repo="github.com/Arkoniak/GrandGameOfLife.jl",
)
