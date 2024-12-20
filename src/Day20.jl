module Day20

using Test

using DataStructures: PriorityQueue, dequeue_pair!
using Memoization

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day20.input")
ans1_file = joinpath(DATA_DIR, "day20.ans1")
ans2_file = joinpath(DATA_DIR, "day20.ans2")

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

@memoize function steps_n_away(n)
    if n ≤ 0
        return Set([CartesianIndex(0, 0)])
    end

    single_steps = [CartesianIndex(-1, 0),
                    CartesianIndex(0, 1),
                    CartesianIndex(1, 0),
                    CartesianIndex(0, -1)]

    return Set(ps + ss
               for ps in steps_n_away(n - 1)
               for ss in single_steps
               if ps + ss ∉ steps_n_away(n - 2))
end

function find_unexplored_neighbors(walls, pos, visited, distance=1)
    new_positions = Iterators.map(steps_n_away(distance)) do step
        return pos + step
    end

    return Iterators.filter(new_positions) do neighbor
        return (checkbounds(Bool, walls, neighbor)
                && !walls[neighbor]
                && neighbor ∉ visited)
    end
end

function find_distances(walls, start)
    distances = Dict{CartesianIndex{2}, Int}()

    cur_pos = start
    distance = 0
    while !isnothing(cur_pos)
        distances[cur_pos] = distance

        distance += 1
        
        next_pos_cand = find_unexplored_neighbors(walls, cur_pos, keys(distances))

        if isempty(next_pos_cand)
            cur_pos = nothing
        else
            cur_pos = only(next_pos_cand)
        end
    end

    return distances
end

function star1(input=stdin; minimum_savings=100)
    walls, start, exit = parse_input(input)
  
    good_cheats = 0

    distance_to_exit = find_distances(walls, exit)
    time_to_beat = distance_to_exit[start]

    visited = Set{CartesianIndex{2}}()

    cur_pos = start
    distance = 0
    while cur_pos != exit
        push!(visited, cur_pos) 

        cheat_candidates = find_unexplored_neighbors(walls, cur_pos, visited, 2)

        for cheat_pos in cheat_candidates
            cheat_time = distance + distance_to_exit[cheat_pos] + 2
            savings = time_to_beat - cheat_time

            if savings ≥ minimum_savings
                good_cheats += 1
            end
        end

        # Go to next position
        distance += 1

        next_pos_cand = find_unexplored_neighbors(walls, cur_pos, visited)

        if isempty(next_pos_cand)
            cur_pos = nothing
        else
            cur_pos = only(next_pos_cand)
        end
    end

    return good_cheats
end

function test_hints_star1()
    @testset "Star 1 hints" begin
    end
end

function star2(input=stdin; minimum_savings=100)
    walls, start, exit = parse_input(input)
  
    good_cheats = 0

    distance_to_exit = find_distances(walls, exit)
    time_to_beat = distance_to_exit[start]

    visited = Set{CartesianIndex{2}}()

    cur_pos = start
    distance = 0
    while cur_pos != exit
        push!(visited, cur_pos) 

        for cheat_steps in 2:20
            cheat_candidates = find_unexplored_neighbors(walls, cur_pos, visited, cheat_steps)

            for cheat_pos in cheat_candidates
                cheat_time = distance + distance_to_exit[cheat_pos] + cheat_steps
                savings = time_to_beat - cheat_time

                if savings ≥ minimum_savings
                    good_cheats += 1
                end
            end
        end

        # Go to next position
        distance += 1

        next_pos_cand = find_unexplored_neighbors(walls, cur_pos, visited)

        if isempty(next_pos_cand)
            cur_pos = nothing
        else
            cur_pos = only(next_pos_cand)
        end
    end

    return good_cheats
end

function test_hints_star2()
    @testset "Star 2 hints" begin
    end
end

end # module Day20
