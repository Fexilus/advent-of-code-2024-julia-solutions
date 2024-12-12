module Day12

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day12.input")
ans1_file = joinpath(DATA_DIR, "day12.ans1")
ans2_file = joinpath(DATA_DIR, "day12.ans2")

parse_input(input) = stack(collect.(eachline(input)); dims=1)

function get_neighbor_indices(index, matrix)
    potential_neighbors = index .+ [CartesianIndex(0, 1),
                                    CartesianIndex(-1, 0),
                                    CartesianIndex(0, -1),
                                    CartesianIndex(1, 0)]

    return filter(i -> checkbounds(Bool, matrix, i), potential_neighbors)
end

function star1(input=stdin)
    lot_matrix = parse_input(input)

    unused_ids = Iterators.Stateful(Iterators.countfrom())
    lot_ids = Dict{CartesianIndex, Int}()
    merged_lots = Dict{Int, Int}()
    region_sizes = Dict{Int, Vector{Int}}()

    for i in eachindex(IndexCartesian(), lot_matrix)
        lot_plant = lot_matrix[i]
        neighbor_i = get_neighbor_indices(i, lot_matrix)

        neighbors_in_region = filter(i -> lot_matrix[i] == lot_plant, neighbor_i)
        id_neighbors_in_region = filter(i -> i ∈ keys(lot_ids), neighbors_in_region)

        # Figure out the id of the lot
        if !isempty(id_neighbors_in_region)
            main_id = lot_ids[first(id_neighbors_in_region)]

            while main_id ∈ keys(merged_lots)
                main_id = merged_lots[main_id]
            end

            # Manage merges of regions
            for other_region_neighbor in Iterators.drop(id_neighbors_in_region, 1)
                other_id = lot_ids[other_region_neighbor]
                
                while other_id ∈ keys(merged_lots)
                    other_id = merged_lots[other_id]
                end

                if other_id != main_id
                    merged_lots[other_id] = main_id
                end
            end
        else
            main_id = popfirst!(unused_ids)
        end

        lot_ids[i] = main_id

        region_size = get!(region_sizes, main_id, [0, 0])

        # Area
        region_size[1] += 1
        # Perimeter
        region_size[2] += 4 - length(neighbors_in_region)
    end

    for id in keys(merged_lots)
        actual_id = merged_lots[id]

        while actual_id ∈ keys(merged_lots)
            actual_id = merged_lots[actual_id]
        end

        region_sizes[actual_id] .+= region_sizes[id]
        delete!(region_sizes, id)
    end

    return sum(values(region_sizes)) do (area, perimeter)
        return area * perimeter
    end
end

hint1 = """
    AAAA
    BBCD
    BBCC
    EEEC
    """

hint2 = """
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    """

hint3 = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 140
        @test star1(IOBuffer(hint2)) == 772
        @test star1(IOBuffer(hint3)) == 1930
    end
end

function star2(input=stdin)
    lot_matrix = parse_input(input)

    unused_ids = Iterators.Stateful(Iterators.countfrom())
    lot_ids = Dict{CartesianIndex, Int}()
    merged_lots = Dict{Int, Int}()

    for i in eachindex(IndexCartesian(), lot_matrix)
        lot_plant = lot_matrix[i]
        neighbor_i = get_neighbor_indices(i, lot_matrix)

        neighbors_in_region = filter(i -> lot_matrix[i] == lot_plant, neighbor_i)
        id_neighbors_in_region = filter(i -> i ∈ keys(lot_ids), neighbors_in_region)

        # Figure out the id of the lot
        if !isempty(id_neighbors_in_region)
            main_id = lot_ids[first(id_neighbors_in_region)]

            while main_id ∈ keys(merged_lots)
                main_id = merged_lots[main_id]
            end

            # Manage merges of regions
            for other_region_neighbor in Iterators.drop(id_neighbors_in_region, 1)
                other_id = lot_ids[other_region_neighbor]
                
                while other_id ∈ keys(merged_lots)
                    other_id = merged_lots[other_id]
                end

                if other_id != main_id
                    merged_lots[other_id] = main_id
                end
            end
        else
            main_id = popfirst!(unused_ids)
        end

        lot_ids[i] = main_id
    end

    for (index, id) in lot_ids
        actual_id = merged_lots[id]

        while actual_id ∈ keys(merged_lots)
            actual_id = merged_lots[actual_id]
        end

        lot_ids[index] = actual_id
    end
end

hint4 = """
    EEEEE
    EXXXX
    EEEEE
    EXXXX
    EEEEE
    """

hint5 = """
    AAAAAA
    AAABBA
    AAABBA
    ABBAAA
    ABBAAA
    AAAAAA
    """

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1)) == 80
        @test star2(IOBuffer(hint2)) == 436
        @test star2(IOBuffer(hint4)) == 236
        @test star2(IOBuffer(hint5)) == 368
        @test star2(IOBuffer(hint3)) == 1206
    end
end

end # module Day12
