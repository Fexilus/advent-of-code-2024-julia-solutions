module Day13

using Test
using LinearAlgebra

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day13.input")
ans1_file = joinpath(DATA_DIR, "day13.ans1")
ans2_file = joinpath(DATA_DIR, "day13.ans2")

function parse_input(input)
    return map(Iterators.partition(eachline(input), 4)) do lines
        a_move = parse.(Int, match(r"Button A: X\+(\d+), Y\+(\d+)", lines[1]).captures)
        b_move = parse.(Int, match(r"Button B: X\+(\d+), Y\+(\d+)", lines[2]).captures)
        goal = parse.(Int, match(r"Prize: X=(\d+), Y=(\d+)", lines[3]).captures)

        return a_move, b_move, goal
    end
end

function star1(input=stdin)
    return sum(parse_input(input)) do (a_move, b_move, goal)
        mat = stack((a_move, b_move); dims=2)

        det_int = mat[1, 1] * mat[2, 2] - mat[2, 1] * mat[1, 2]
        adjugate_int = [mat[2, 2]  -mat[1, 2]
                        -mat[2, 1] mat[1, 1]]

        if all(rem.(adjugate_int * goal, det_int) .== 0)
            @info "Machine possible" a_move, b_move, goal
            required_moves = adjugate_int * goal .÷ det_int
            
            cost = required_moves ⋅ [3, 1]
            @debug "Cost" cost

            return cost
        else
            return 0
        end
    end
end

hint1 = """
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 480
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

end # module Day13
