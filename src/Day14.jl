module Day14

using Test

using UnicodePlots: scatterplot

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day14.input")
ans1_file = joinpath(DATA_DIR, "day14.ans1")
ans2_file = joinpath(DATA_DIR, "day14.ans2")

function parse_robot(line)
    m = match(r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)", line)
    pos = parse.(Int, m.captures[1:2])
    vel = parse.(Int, m.captures[3:4])

    return pos, vel
end

function calc_pos((pos, vel), time, map_size)
    mod.(pos + time * vel, map_size)
end

function star1(input=stdin; map_size=[101, 103])
    in_quardant = [0, 0, 0, 0]

    for line in eachline(input)
        robot = parse_robot(line)
        new_pos = calc_pos(robot, 100, map_size)

        @debug "Robot has new pos" new_pos

        if new_pos[1] in 0:((map_size[1] - 2) ÷ 2)
            if new_pos[2] in 0:((map_size[2] - 2) ÷ 2)
                in_quardant[2] += 1
            elseif new_pos[2] in ((map_size[2] + 1) ÷ 2):(map_size[2] - 1)
                in_quardant[3] += 1
            end
        elseif new_pos[1] in ((map_size[1] + 1) ÷ 2):(map_size[1] - 1)
            if new_pos[2] in 0:((map_size[2] - 2) ÷ 2)
                in_quardant[1] += 1
            elseif new_pos[2] in ((map_size[2] + 1) ÷ 2):(map_size[2] - 1)
                in_quardant[4] += 1
            end
        end
    end

    @debug "Robots in quadrants" in_quardant

    return prod(in_quardant)
end

hint1 = """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1); map_size=[11, 7]) == 12
    end
end

function star2(input=stdin; map_size=[101, 103])
    robots = map(parse_robot, eachline(input))

    cur_positions = map(first, robots)
    vels = map(last, robots)

    step_size = 1

    steps = 0
    while (line = readline(stdin)) != "q"
        if line != ""
            step_size = parse(Int, line)
        end

        steps += step_size

        for (i, (pos, vel)) in enumerate(zip(cur_positions, vels))
            cur_positions[i] = mod.(pos + step_size * vel, map_size)
        end

        xs = map(first, cur_positions)
        ys = map(last, cur_positions)

        show(scatterplot(xs, ys;
                         xlim=(0, map_size[1] - 1),
                         ylim=(0, map_size[2] - 1),
                         yflip=true,
                         title=string(steps)))
        println()
    end
end

function test_hints_star2()
    @testset "Star 2 hints" begin
    end
end

end # module Day14
