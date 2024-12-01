module Day01

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day01.input")
ans1_file = joinpath(DATA_DIR, "day01.ans1")
ans2_file = joinpath(DATA_DIR, "day01.ans2")

function parse_line(line)
    left, right = split(line; limit=2)
    return parse(Int, left), parse(Int, right)
end

parse_input(input) = Iterators.map(parse_line, eachline(input))

function star1(input=stdin)
    left_list = Int[]
    right_list = Int[]

    for (left, right) in parse_input(input)
        push!(left_list, left)
        push!(right_list, right)
    end

    sort!(left_list)
    sort!(right_list)

    return sum(zip(left_list, right_list)) do (left, right)
        abs(left - right)
    end
end

hint1 = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 11
    end
end

function star2(input=stdin)
    left_list = Int[]
    right_occurances = Dict{Int, Int}()

    for (left, right) in parse_input(input)
        push!(left_list, left)

        get!(right_occurances, right, 0)
        right_occurances[right] += 1
    end

    return sum(left_list) do left
        left * get!(right_occurances, left, 0)
    end
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1)) == 31
    end
end

end # module Day01
