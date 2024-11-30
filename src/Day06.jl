module Day06

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day06.input")
ans1_file = joinpath(DATA_DIR, "day06.ans1")
ans2_file = joinpath(DATA_DIR, "day06.ans2")

function star1(input=stdin)
end

hint1 = """
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        #@test star1(IOBuffer(hint1)) ==
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

end # module Day06
