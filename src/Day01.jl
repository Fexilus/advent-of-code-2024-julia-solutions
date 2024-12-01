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

function star1(input=stdin)
    left_list = Int[]
    right_list = Int[]

    for line in eachline(input)
        left, right = split(line; limit=2)

        push!(left_list, parse(Int, left))
        push!(right_list, parse(Int, right))
    end

    return sum(zip(sort(left_list), sort(right_list))) do (left, right)
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
    right_list = Int[]

    for line in eachline(input)
        left, right = split(line; limit=2)

        push!(left_list, parse(Int, left))
        push!(right_list, parse(Int, right))
    end
    right_occurances = Dict{Int, Int}()

    for right in right_list
        old_val = get!(right_occurances, right, 0)

        right_occurances[right] = old_val + 1
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
