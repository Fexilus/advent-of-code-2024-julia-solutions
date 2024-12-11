module Day11

using Test

using Memoization: @memoize

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day11.input")
ans1_file = joinpath(DATA_DIR, "day11.ans1")
ans2_file = joinpath(DATA_DIR, "day11.ans2")

parse_input(input) = parse.(Int, split(readline(input)))

function star1(input=stdin)
    stones = parse_input(input)

    for i in 1:25
        new_stones = Int[]

        for stone in stones
            if stone == 0
                push!(new_stones, 1)
            elseif iseven(ndigits(stone))
                upper, lower = divrem(stone, 10^(ndigits(stone) ÷ 2))
                push!(new_stones, upper)
                push!(new_stones, lower)
            else
                push!(new_stones, stone * 2024)
            end
        end

        stones = new_stones
    end
    
    return length(stones)
end

hint1 = """
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        #@test star1(IOBuffer(hint1)) ==
    end
end


@memoize function stone_decendants(stone, steps)
    if steps == 0
        return 1
    elseif stone == 0
        return stone_decendants(1, steps - 1)
    elseif iseven(ndigits(stone))
        upper, lower = divrem(stone, 10^(ndigits(stone) ÷ 2))
        return stone_decendants(upper, steps - 1) + stone_decendants(lower, steps - 1)
    else
        return stone_decendants(stone * 2024, steps - 1)
    end
end

function star2(input=stdin)
    stones = parse_input(input)

    return sum(stones) do stone
        return stone_decendants(stone, 75)
    end
end

hint2 = """
    """

function test_hints_star2()
    @testset "Star 2 hints" begin
        #@test star2(IOBuffer(hint2)) ==
    end
end

end # module Day11
