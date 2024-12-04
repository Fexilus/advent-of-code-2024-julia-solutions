module Day04

using Base: Cartesian
using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day04.input")
ans1_file = joinpath(DATA_DIR, "day04.ans1")
ans2_file = joinpath(DATA_DIR, "day04.ans2")

parse_input(input) = stack(readlines(input); dims=1)

function star1(input=stdin)
    matrix = parse_input(input)

    c = 0
    for transformed_matrix in [matrix, rotl90(matrix), rot180(matrix), rotr90(matrix)]
        for i in eachindex(IndexCartesian(), transformed_matrix)
            k, l = Tuple(i)
            if transformed_matrix[k, l] == 'X'
                @debug "" transformed_matrix
                if (k ≤ size(transformed_matrix, 2) - 3
                    && transformed_matrix[k + 1, l] == 'M'
                    && transformed_matrix[k + 2, l] == 'A'
                    && transformed_matrix[k + 3, l] == 'S'
                   )

                    c += 1
                end
                if (k ≤ size(transformed_matrix, 2) - 3
                    && l ≤ size(transformed_matrix, 1) - 3
                    && transformed_matrix[k + 1, l + 1] == 'M'
                    && transformed_matrix[k + 2, l + 2] == 'A'
                    && transformed_matrix[k + 3, l + 3] == 'S'
                   )

                    c += 1
                end
            end
        end
    end

    return c
end

hint1 = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 18
    end
end

function star2(input=stdin)
    matrix = parse_input(input)

    c = 0
    for transformed_matrix in [matrix, rotl90(matrix), rot180(matrix), rotr90(matrix)]
        for i in eachindex(IndexCartesian(), transformed_matrix)
            k, l = Tuple(i)
            if transformed_matrix[k, l] == 'M'
                if (k ≤ size(transformed_matrix, 2) - 2
                    && l ≤ size(transformed_matrix, 1) - 2
                    && transformed_matrix[k + 1, l + 1] == 'A'
                    && transformed_matrix[k + 2, l + 2] == 'S'
                    && transformed_matrix[k + 2, l    ] == 'M'
                    && transformed_matrix[k    , l + 2] == 'S'
                   )

                    c += 1
                end
            end
        end
    end

    return c
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1)) == 9
    end
end

end # module Day04
