module Day02

using Test
using Logging

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day02.input")
ans1_file = joinpath(DATA_DIR, "day02.ans1")
ans2_file = joinpath(DATA_DIR, "day02.ans2")

parse_report(line) = parse.(Int, split(line))

function star1(input=stdin)
    return sum(eachline(input)) do line
        report = parse_report(line)

        dec = all(d -> (1 ≤ d ≤ 3), diff(report))
        inc = all(d -> (-3 ≤ d ≤ -1), diff(report))

        @debug "" report, dec, inc

        if dec || inc
            return 1
        else
            return 0
        end
    end
end

hint1 = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 2
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

end # module Day02
