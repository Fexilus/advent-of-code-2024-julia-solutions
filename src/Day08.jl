module Day08

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day08.input")
ans1_file = joinpath(DATA_DIR, "day08.ans1")
ans2_file = joinpath(DATA_DIR, "day08.ans2")

function parse_input(input)
    antenna_locations = Dict{Char, Vector{CartesianIndex}}()
    height = 0
    width = nothing

    for line in readlines(input)
        height +=1
        width = length(line)

        for m in eachmatch(r"(\w)", line)
            loc = CartesianIndex(height, m.offset)
            c = Char(only(m.match))

            push!(get!(antenna_locations, c, []), loc)
        end
    end

    return (height, width), antenna_locations
end

function star1(input=stdin)
    (height, width), antenna_locations = parse_input(input)
    anti_locations = Set{CartesianIndex}()

    bounds = CartesianIndices((height, width))

    for (c, locations) in antenna_locations
        @debug "Solving antennas" c
        for loc1 in locations
            for loc2 in locations
                if loc1 === loc2
                    continue
                end

                potential_anti_loc = 2 * loc1 - loc2

                if potential_anti_loc ∈ bounds
                    push!(anti_locations, potential_anti_loc)
                end
            end
        end
    end

    return length(anti_locations)
end

hint1 = """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 14
    end
end

function star2(input=stdin)
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1)) == 34
    end
end

end # module Day08
