module Day20

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

function find_unexplored_neighbors(map, pos, visited)
    neighbors = pos .+ [CartesianIndex(-1, 0),
                        CartesianIndex(0, 1),
                        CartesianIndex(1, 0),
                        CartesianIndex(0, -1)]

    next_pos_cand = filter(p -> checkbounds(Bool, map, p), neighbors)
    next_pos_cand = filter(p -> !map[p], next_pos_cand)
    return filter(∉(visited), next_pos_cand)
end

function find_distances(map, start)
    distances = Dict{CartesianIndex{2}, Int}()

    cur_pos = start
    distance = 0
    while !isnothing(cur_pos)
        distances[cur_pos] = distance

        distance += 1
        
        next_pos_cand = find_unexplored_neighbors(map, cur_pos, keys(distances))

        if isempty(next_pos_cand)
            cur_pos = nothing
        elseif length(next_pos_cand) == 1
            cur_pos = only(next_pos_cand)
        else
            error("Map is not one path")
        end
    end

    return distances
end

function find_unexplored_2neighbors(map, pos, visited)
    neighbors = pos .+ [CartesianIndex(-2, 0),
                        CartesianIndex(-1, 1),
                        CartesianIndex(0, 2),
                        CartesianIndex(1, 1),
                        CartesianIndex(2, 0),
                        CartesianIndex(1, -1),
                        CartesianIndex(0, -2),
                        CartesianIndex(-1, -1)]

    next_pos_cand = filter(p -> checkbounds(Bool, map, p), neighbors)
    next_pos_cand = filter(p -> !map[p], next_pos_cand)
    return filter(∉(visited), next_pos_cand)
end

function star1(input=stdin; minimum_savings=100)
    walls, start, exit = parse_input(input)
  
    good_cheats = Dict{Tuple{CartesianIndex, CartesianIndex}, Int}()

    distance_to_exit = find_distances(walls, exit)
    time_to_beat = distance_to_exit[start]

    visited = Set{CartesianIndex{2}}()

    cur_pos = start
    distance = 0
    while cur_pos != exit
        push!(visited, cur_pos) 

        cheat_candidates = find_unexplored_2neighbors(walls, cur_pos, visited)

        for cheat_pos in cheat_candidates
            cheat_time = distance + distance_to_exit[cheat_pos] + 2
            savings = time_to_beat - cheat_time

            if savings ≥ minimum_savings
                good_cheats[(cur_pos, cheat_pos)] = savings
            end
        end

        # Go to next position
        distance += 1

        next_pos_cand = find_unexplored_neighbors(walls, cur_pos, visited)

        if isempty(next_pos_cand)
            cur_pos = nothing
        elseif length(next_pos_cand) == 1
            cur_pos = only(next_pos_cand)
        else
            error("Map is not one path")
        end
    end

    return length(good_cheats)
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

end # module Day20
