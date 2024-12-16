module Day16

using Test

using DataStructures: PriorityQueue, dequeue_pair!

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day16.input")
ans1_file = joinpath(DATA_DIR, "day16.ans1")
ans2_file = joinpath(DATA_DIR, "day16.ans2")

function parse_input(input)
    start = missing
    exit = missing

    walls = stack(enumerate(eachline(input)); dims=1) do (k, line)
        if occursin("S", line)
            start = CartesianIndex(k, findfirst('S', line))
        end

        if occursin("E", line)
            exit = CartesianIndex(k, findfirst('E', line))
        end

        return collect(line) .== '#'
    end

    return walls, start, exit
end

const State = Tuple{CartesianIndex{2}, Symbol}

function star1(input=stdin)
    walls, start, exit = parse_input(input)

    visited = Set{State}()
    unexplored = PriorityQueue((start, :right) => 0)

    while !isempty(unexplored)
        (pos, dir), score = dequeue_pair!(unexplored)

        @debug "At" pos

        if pos == exit
            return score
        elseif walls[pos]
            continue
        end

        if dir === :up
            forward_pos = pos + CartesianIndex(-1, 0)
            clockwise_dir = :right
            counterclockwise_dir = :left
        elseif dir === :right
            forward_pos = pos + CartesianIndex(0, 1)
            clockwise_dir = :down
            counterclockwise_dir = :up
        elseif dir === :down
            forward_pos = pos + CartesianIndex(1, 0)
            clockwise_dir = :left
            counterclockwise_dir = :right
        elseif dir === :left
            forward_pos = pos + CartesianIndex(0, -1)
            clockwise_dir = :up
            counterclockwise_dir = :down
        end

        potential_states = [((forward_pos, dir), 1),
                            ((pos, clockwise_dir), 1000),
                            ((pos, counterclockwise_dir), 1000)]

        for (state, extra_score) in potential_states
            if state ∉ visited
                prev_score = get(unexplored, state, Inf)
                unexplored[state] = min(score + extra_score, prev_score)
            end
        end

        push!(visited, (pos, dir))
    end
end

hint1 = """
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
    """

hint2 = """
    #################
    #...#...#...#..E#
    #.#.#.#.#.#.#.#.#
    #.#.#.#...#...#.#
    #.#.#.#.###.#.#.#
    #...#.#.#.....#.#
    #.#.#.#.#.#####.#
    #.#...#.#.#.....#
    #.#.#####.#.###.#
    #.#.#.......#...#
    #.#.###.#####.###
    #.#.#...#.....#.#
    #.#.#.#####.###.#
    #.#.#.........#.#
    #.#.#.#########.#
    #S#.............#
    #################
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 7036
        @test star1(IOBuffer(hint2)) == 11048
    end
end

function star2(input=stdin)
    walls, start, exit = parse_input(input)

    visited = Set{State}()
    unexplored = PriorityQueue((start, :right) => 0)
    best_prev_spots = Dict{State, Vector{State}}()
    best_score = missing
    exit_states = Set{State}()

    while !isempty(unexplored)
        (pos, dir), score = dequeue_pair!(unexplored)

        @debug "At" pos

        if pos == exit
            if ismissing(best_score)
                best_score = score
            elseif score > best_score
                break
            end

            push!(exit_states, (pos, dir))

            continue
        elseif walls[pos]
            continue
        end

        if dir === :up
            forward_pos = pos + CartesianIndex(-1, 0)
            clockwise_dir = :right
            counterclockwise_dir = :left
        elseif dir === :right
            forward_pos = pos + CartesianIndex(0, 1)
            clockwise_dir = :down
            counterclockwise_dir = :up
        elseif dir === :down
            forward_pos = pos + CartesianIndex(1, 0)
            clockwise_dir = :left
            counterclockwise_dir = :right
        elseif dir === :left
            forward_pos = pos + CartesianIndex(0, -1)
            clockwise_dir = :up
            counterclockwise_dir = :down
        end

        potential_states = [((forward_pos, dir), 1),
                            ((pos, clockwise_dir), 1000),
                            ((pos, counterclockwise_dir), 1000)]

        for (state, extra_score) in potential_states
            if state ∉ visited
                prev_score = get(unexplored, state, Inf)
                new_score = score + extra_score

                unexplored[state] = min(new_score, prev_score)

                if new_score < prev_score
                    best_prev_spots[state] = [(pos, dir)]
                elseif new_score == prev_score
                    push!(best_prev_spots[state], (pos, dir))
                end
            end

        end

        push!(visited, (pos, dir))
    end

    on_best_path = Set{CartesianIndex{2}}()
    untraced_states = collect(exit_states)

    while !isempty(untraced_states)
        pos, dir = pop!(untraced_states)

        if pos != start
            append!(untraced_states, best_prev_spots[(pos, dir)])
        end

        push!(on_best_path, pos)
    end

    return length(on_best_path)
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1)) == 45
        @test star2(IOBuffer(hint2)) == 64
    end
end

end # module Day16
