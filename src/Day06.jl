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

function parse_input(input)
    raw_matrix = stack(readlines(input); dims=1)

    puzzle_map = raw_matrix .== '#'

    starting_pos = findfirst(∈("^"), raw_matrix)
    starting_dir = :up

    return puzzle_map, starting_pos, starting_dir
end

function get_visited_locations(puzzle_map, cur_pos, cur_dir)
    visited = zero(puzzle_map)
    visited_state = Set{Tuple{CartesianIndex, Symbol}}()

    inf_loop = false

    while !isnothing(cur_pos)
        @debug "At" cur_pos, cur_dir

        if (cur_pos, cur_dir) ∈ visited_state
            @debug "Infinite loop, exiting"
            inf_loop = true
            break
        else
            push!(visited_state, (cur_pos, cur_dir))
        end

        if cur_dir === :up
            next_ind = findprev(selectdim(puzzle_map, 2, cur_pos[2]), cur_pos[1])

            if isnothing(next_ind) 
                next_pos = nothing
                virt_pos = CartesianIndex(1, cur_pos[2])
            else
                next_pos = virt_pos = CartesianIndex(next_ind + 1, cur_pos[2])
            end

            visited[virt_pos:cur_pos] .= true

            cur_pos = next_pos
            cur_dir = :right
        elseif cur_dir === :right
            next_ind = findnext(selectdim(puzzle_map, 1, cur_pos[1]), cur_pos[2])

            if isnothing(next_ind) 
                next_pos = nothing
                virt_pos = CartesianIndex(cur_pos[1], size(puzzle_map, 2))
            else
                next_pos = virt_pos = CartesianIndex(cur_pos[1], next_ind - 1)
            end

            visited[cur_pos:virt_pos] .= true

            cur_pos = next_pos
            cur_dir = :down
        elseif cur_dir === :down
            next_ind = findnext(selectdim(puzzle_map, 2, cur_pos[2]), cur_pos[1])

            if isnothing(next_ind) 
                next_pos = nothing
                virt_pos = CartesianIndex(size(puzzle_map, 1), cur_pos[2])
            else
                next_pos = virt_pos = CartesianIndex(next_ind - 1, cur_pos[2])
            end

            visited[cur_pos:virt_pos] .= true

            cur_pos = next_pos
            cur_dir = :left
        elseif cur_dir === :left
            next_ind = findprev(selectdim(puzzle_map, 1, cur_pos[1]), cur_pos[2])

            if isnothing(next_ind) 
                next_pos = nothing
                virt_pos = CartesianIndex(cur_pos[1], 1)
            else
                next_pos = virt_pos = CartesianIndex(cur_pos[1], next_ind + 1)
            end
                
            visited[virt_pos:cur_pos] .= true

            cur_pos = next_pos
            cur_dir = :up
        end
    end

    @debug "Done"

    return visited, inf_loop
end

function star1(input=stdin)
    puzzle_map, init_pos, init_dir = parse_input(input)

    visited, _ = get_visited_locations(puzzle_map, init_pos, init_dir)

    return count(visited)
end

hint1 = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 41
    end
end

function star2(input=stdin)
    puzzle_map, init_pos, init_dir = parse_input(input)

    visited, _ = get_visited_locations(puzzle_map, init_pos, init_dir)

    mod_puzzle_map = copy(puzzle_map)

    return count(findall(visited)) do visited_loc
        if visited_loc == init_pos
            return false
        end

        mod_puzzle_map[visited_loc] = true

        _, inf_loop = get_visited_locations(mod_puzzle_map, init_pos, init_dir)

        mod_puzzle_map[visited_loc] = false

        return inf_loop
    end
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1)) == 6
    end
end

end # module Day06
