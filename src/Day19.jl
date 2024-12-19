module Day19

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day19.input")
ans1_file = joinpath(DATA_DIR, "day19.ans1")
ans2_file = joinpath(DATA_DIR, "day19.ans2")

function parse_input(input)
    lines = Iterators.Stateful(eachline(input))

    towels = split(popfirst!(lines), ", ")

    popfirst!(lines)

    patterns = collect(lines)

    return towels, patterns
end

function can_construct(pattern, towels)
    @debug "" pattern

    if isempty(pattern)
        return true
    end

    for towel in towels
        if length(pattern) ≥ length(towel)
            if pattern[1:length(towel)] == towel
                if can_construct(pattern[length(towel)+1:end], towels)
                    return true
                end
            end
        end
    end

    return false
end

function star1(input=stdin)
    towels, patterns = parse_input(input)

    return sum(patterns) do pattern
        if can_construct(pattern, towels)
            return 1
        else
            return 0
        end
    end
end

hint1 = """
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    bggr
    gbbr
    rrbgbr
    ubwu
    bwurrg
    brgr
    bbrgwb
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 6
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

end # module Day19
