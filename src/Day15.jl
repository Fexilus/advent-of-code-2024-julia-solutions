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

function parse_input_wide(input)
    lines = Iterators.Stateful(eachline(input))

    walls = Vector{Bool}[]
    initial_boxes = Vector{Union{Symbol, Nothing}}[]
    initial_pos = missing

    for (k, line) in enumerate(lines)
        if isempty(line)
            break
        end

        wall_line = Bool[]
        box_line = Union{Symbol, Nothing}[]

        for (l, c) in enumerate(line)
            if c == '#'
                append!(wall_line, [true, true])
            else
                append!(wall_line, [false, false])
            end
            
            if c == 'O'
                append!(box_line, [:l, :r])
            else
                append!(box_line, [nothing, nothing])
            end
        
            if c == '@'
                initial_pos = CartesianIndex(k, 2 * l - 1)
            end
        end

        push!(walls, wall_line)
        push!(initial_boxes, box_line)
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

function star2(input=stdin)
    walls, boxes, pos, moves = parse_input_wide(input)

    @debug "Walls" walls
    @debug "Initial boxes" boxes
    
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
        
        next_space = [pos + pos_shift]
        
        boxes_to_move = Dict{CartesianIndex, Symbol}()
        can_move = true

        while !isempty(next_space)
            box_pos = pop!(next_space)

            if isnothing(boxes[box_pos])
                if walls[box_pos]
                    can_move = false
                    break
                else
                    continue
                end
            end

            if boxes[box_pos] === :l
                pair_box_pos = box_pos + CartesianIndex(0, 1)
                @assert boxes[pair_box_pos] === :r
            elseif boxes[box_pos] == :r
                pair_box_pos = box_pos - CartesianIndex(0, 1)
                @assert boxes[pair_box_pos] === :l
            else
                error("Unknown box symbol $(boxes[box_pos])")
            end

            boxes_to_move[box_pos] = boxes[box_pos] 
            boxes_to_move[pair_box_pos] = boxes[pair_box_pos] 

            if move === :left || move === :right
                push!(next_space, pair_box_pos + pos_shift)
            else
                push!(next_space, box_pos + pos_shift)
                push!(next_space, pair_box_pos + pos_shift)
            end
        end

        if can_move
            for prev_box_pos in keys(boxes_to_move)
                boxes[prev_box_pos] = nothing
            end

            for (prev_box_pos, box_type) in boxes_to_move
                boxes[prev_box_pos + pos_shift] = box_type
            end

            pos += pos_shift
        end
    
        @debug "Boxes" boxes
    end

    @debug "Final boxes" boxes

    return sum(findall(!isnothing, boxes)) do box_pos
        if boxes[box_pos] === :l
            k, l = Tuple(box_pos)
            return 100 * (k - 1) + l - 1
        else
            return 0
        end
    end
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint2)) == 9021
    end
end

end # module Day15
