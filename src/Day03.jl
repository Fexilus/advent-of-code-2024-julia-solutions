module Day03

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day03.input")
ans1_file = joinpath(DATA_DIR, "day03.ans1")
ans2_file = joinpath(DATA_DIR, "day03.ans2")

mul_regex = r"mul\((\d{1,3}),(\d{1,3})\)"

function star1(input=stdin)
    s = 0
    for line in eachline(input)
        for regex_match in eachmatch(mul_regex, line)
            num1 = parse(Int, regex_match.captures[1])
            num2 = parse(Int, regex_match.captures[2])
            s += num1 * num2
        end
    end

    return s
end

hint1 = """
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 161
    end
end

function star2(input=stdin)
end

hint2 = """
    """

function test_hints_star2()
    @testset "Star 2 hints" begin
        #@test star2(IOBuffer(hint2)) ==
    end
end

end # module Day03
