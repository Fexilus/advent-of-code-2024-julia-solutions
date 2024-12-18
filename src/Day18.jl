module Day18

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

input_file = joinpath(DATA_DIR, "day18.input")
ans1_file = joinpath(DATA_DIR, "day18.ans1")
ans2_file = joinpath(DATA_DIR, "day18.ans2")

function parse_line(line)
    m = match(r"(\d+),(\d+)", line)

    return CartesianIndex((parse.(Int, m.captures) .+ 1)...)
end

function get_uncorrupted_neighbors(corruptions, pos)
    neighbor_shifts = [CartesianIndex(-1, 0),
                       CartesianIndex(0, 1),
                       CartesianIndex(1, 0),
                       CartesianIndex(0, -1)]

    return filter(pos .+ neighbor_shifts) do new_pos
        return checkbounds(Bool, corruptions, new_pos) && !corruptions[new_pos]
    end
end

function shortest_path(corruptions, start, stop)
    visited = Set{CartesianIndex}()
    unexplored = PriorityQueue(start => 0)

    while !isempty(unexplored)
        pos, score = dequeue_pair!(unexplored)

        if pos == stop
            return score
        end

        for next_pos in get_uncorrupted_neighbors(corruptions, pos)
            if next_pos ∉ visited
                unexplored[next_pos] = min(score + 1,
                                           get(unexplored, next_pos, Inf))
            end
        end

        push!(visited, pos)
    end
end

function star1(input=stdin; size=(71, 71), fallen_bytes=1024)
    start = CartesianIndex(0 + 1, 0 + 1)
    stop = CartesianIndex(size...)

    corruptions = falses(size)

    for line in Iterators.take(eachline(input), fallen_bytes)
        corrupted_index = parse_line(line)
        corruptions[corrupted_index] = true
    end

    @debug "Map:" corruptions
   
    return shortest_path(corruptions, start, stop)
end

hint1 = """
    5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1); size=(7, 7), fallen_bytes=12) == 22
    end
end

function star2(input=stdin; size=(71, 71))
    start = CartesianIndex(0 + 1, 0 + 1)
    stop = CartesianIndex(size...)

    corruptions = falses(size)

    for line in eachline(input)
        corrupted_index = parse_line(line)
        corruptions[corrupted_index] = true
        
        if isnothing(shortest_path(corruptions, start, stop))
            return "$(corrupted_index[1] - 1),$(corrupted_index[2] - 1)"
        end
    end 
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1); size=(7, 7)) == "6,1"
    end
end

end # module Day18
