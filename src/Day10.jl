module Day10

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day10.input")
ans1_file = joinpath(DATA_DIR, "day10.ans1")
ans2_file = joinpath(DATA_DIR, "day10.ans2")

function parse_input(input)
    return stack(eachline(input); dims=1) do line
        return collect(parse(Int, c) for c in line)
    end
end

function get_neighbor_indices(matrix, index)
    neighbors = index .- [CartesianIndex(1, 0),
                          CartesianIndex(0, -1),
                          CartesianIndex(-1, 0),
                          CartesianIndex(0, 1)]

    return filter(i -> checkbounds(Bool, matrix, i), neighbors)
end

function find_peaks!(reachable_peaks, topo_map, index)
    val = topo_map[index]

    if val == 9
        push!(reachable_peaks, index)
    else
        for neighbor_index in get_neighbor_indices(topo_map, index)
            if topo_map[neighbor_index] == val + 1
                find_peaks!(reachable_peaks, topo_map, neighbor_index)
            end
        end
    end
end

function star1(input=stdin)
    topo_map = parse_input(input)

    return sum(findall(==(0), topo_map)) do index
        reachable_peaks = Set{CartesianIndex}()
        find_peaks!(reachable_peaks, topo_map, index)

        return length(reachable_peaks)
    end
end

hint1 = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 36
    end
end

function score_index(topo_map, index)
    val = topo_map[index]

    if val == 9
        return 1
    end

    score = 0
    for neighbor_index in get_neighbor_indices(topo_map, index)
        if topo_map[neighbor_index] == val + 1
            score += score_index(topo_map, neighbor_index)
        end
    end

    return score
end

function star2(input=stdin)
    topo_map = parse_input(input)

    return sum(eachindex(IndexCartesian(), topo_map)) do index
        if topo_map[index] == 0
            return score_index(topo_map, index)
        else
            return 0
        end
    end
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1)) == 81
    end
end

end # module Day10
