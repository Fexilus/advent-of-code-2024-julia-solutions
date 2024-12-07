module Day07

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day07.input")
ans1_file = joinpath(DATA_DIR, "day07.ans1")
ans2_file = joinpath(DATA_DIR, "day07.ans2")

function parse_line(line)
    full_match = match(r"(\d+):\s*((?:\d+\s*)*)", line)
    total = parse(Int, full_match.captures[1])
    numbers = parse.(Int, split(full_match.captures[2]))

    return total, numbers
end

concat(a, b) = a * 10^ndigits(b) + b

function can_get_tot(goal, first_val, further_vals; allow_concat=true)
    if isempty(further_vals)
        return goal == first_val
    end

    possible_mult = can_get_tot(goal, first_val * further_vals[1], @view further_vals[2:end]; allow_concat)
    possible_add = can_get_tot(goal, first_val + further_vals[1], @view further_vals[2:end]; allow_concat)
    if allow_concat
        possible_concat = can_get_tot(goal, concat(first_val, further_vals[1]), @view further_vals[2:end]; allow_concat)
    else
        possible_concat = false
    end

    return possible_mult || possible_add || possible_concat
end

can_get_tot(goal, vals; kwargs...) = can_get_tot(goal, vals[1], @view vals[2:end]; kwargs...)


function star1(input=stdin)
    return sum(eachline(input)) do line
        goal, values = parse_line(line)
        @debug "With" goal, values

        if can_get_tot(goal, values; allow_concat=false)
            return goal
        else
            return 0
        end
    end
end

hint1 = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 3749
    end
end

function star2(input=stdin)
    return sum(eachline(input)) do line
        goal, values = parse_line(line)
        @debug "With" goal, values

        if can_get_tot(goal, values)
            return goal
        else
            return 0
        end
    end
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1)) == 11387
    end
end

end # module Day07
