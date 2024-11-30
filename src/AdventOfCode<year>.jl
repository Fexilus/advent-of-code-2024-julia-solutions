module AdventOfCode<year>

export Day01
export Day02
export Day03
export Day04
export Day05
export Day06
export Day07
export Day08
export Day09
export Day10
export Day11
export Day12
export Day13
export Day14
export Day15
export Day16
export Day17
export Day18
export Day19
export Day20
export Day21
export Day22
export Day23
export Day24
export Day25

module Utils
    export DATA_DIR

    const BASE_DIR = dirname(dirname(@__FILE__))
    const DATA_DIR = joinpath(BASE_DIR, "data")
end

include("Day01.jl")
include("Day02.jl")
include("Day03.jl")
include("Day04.jl")
include("Day05.jl")
include("Day06.jl")
include("Day07.jl")
include("Day08.jl")
include("Day09.jl")
include("Day10.jl")
include("Day11.jl")
include("Day12.jl")
include("Day13.jl")
include("Day14.jl")
include("Day15.jl")
include("Day16.jl")
include("Day17.jl")
include("Day18.jl")
include("Day19.jl")
include("Day20.jl")
include("Day21.jl")
include("Day22.jl")
include("Day23.jl")
include("Day24.jl")
include("Day25.jl")

end # module AdventOfCode<year>
