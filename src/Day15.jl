module Day15

using Test

using UnicodePlots: spy

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day15.input")
ans1_file = joinpath(DATA_DIR, "day15.ans1")
ans2_file = joinpath(DATA_DIR, "day15.ans2")

function parse_input(input)
    lines = Iterators.Stateful(eachline(input))

    walls = Vector{Bool}[]
    initial_boxes = Vector{Bool}[]
    initial_pos = missing

    for (k, line) in enumerate(lines)
        if line == ""
            break
        end

        push!(walls, '#' .== collect(line))
        push!(initial_boxes, 'O' .== collect(line))
        
        if '@' in line
            initial_pos = CartesianIndex(k, findfirst('@', line))
        end
    end

    moves = Symbol[]

    for line in lines
        for c in line
            if c == '^'
                push!(moves, :up)
            elseif c == '>'
                push!(moves, :right)
            elseif c == 'v'
                push!(moves, :down)
            elseif c == '<'
                push!(moves, :left)
            else
                error("Unknown direction $c")
            end
        end
    end

    return stack(walls; dims=1), stack(initial_boxes; dims=1), initial_pos, moves
end

function star1(input=stdin)
    walls, boxes, pos, moves = parse_input(input)

    @debug "Walls" spy(walls)
    @debug "Initial boxes" spy(boxes)

    for move in moves
        if move === :up
            pos_shift = CartesianIndex(-1, 0)
        elseif move === :right
            pos_shift = CartesianIndex(0, 1)
        elseif move === :down
            pos_shift = CartesianIndex(1, 0)
        elseif move === :left
            pos_shift = CartesianIndex(0, -1)
        else
            error("Unknown direction symbol $move")
        end

        next_space = pos + pos_shift

        boxes_to_move = CartesianIndex[]

        while boxes[next_space]
            push!(boxes_to_move, next_space)

            next_space += pos_shift
        end

        if !walls[next_space]
            pos += pos_shift

            if !isempty(boxes_to_move)
                boxes[first(boxes_to_move)] = false
                boxes[next_space] = true
            end
        end
    end

    @debug "Final boxes" spy(boxes)

    return sum(findall(boxes)) do pos
        k, l = Tuple(pos)
        return 100 * (k - 1) + l - 1
    end
end

hint1 = """
    ########
    #..O.O.#
    ##@.O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    <^^>>>vv<v>>v<<
    """

hint2 = """
    ##########
    #..O..O.O#
    #......O.#
    #.OO..O.O#
    #..O@..O.#
    #O#..O...#
    #O..O..O.#
    #.OO.O.OO#
    #....O...#
    ##########

    <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
    vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
    ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
    <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
    ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
    ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
    >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
    <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
    ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
    v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 2028
        @test star1(IOBuffer(hint2)) == 10092
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

end # module Day15
