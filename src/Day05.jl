module Day05

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day05.input")
ans1_file = joinpath(DATA_DIR, "day05.ans1")
ans2_file = joinpath(DATA_DIR, "day05.ans2")

function parse_input(input)
    lines = Iterators.Stateful(eachline(input))

    rules = Dict{Int, Vector{Int}}()

    for line in lines
        if line == ""
            break
        else
            a, b = parse.(Int, match(r"(\d*)\|(\d*)", line).captures)

            push!(get!(rules, a, []), b)
        end
    end

    updates = Vector{Int}[]

    for line in lines
        push!(updates, parse.(Int, split(line, ",")))
    end

    return rules, updates
end

function star1(input=stdin)
    rules, updates = parse_input(input)

    s = 0
    for update in updates
        @debug "Update" update
        prev_numbers = Int[]

        valid_update = true
        for val in update
            if isdisjoint(prev_numbers, get(rules, val, []))
                push!(prev_numbers, val)
            else
                valid_update = false
                break
            end
        end

        @debug "" valid_update
        if valid_update
            s += update[end ÷ 2 + 1]
        end
    end

    return s
end

hint1 = """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 143
    end
end

function star2(input=stdin)
    rules, updates = parse_input(input)

    s = 0
    for update in updates
        @debug "Update" update
        prev_numbers = Int[]

        valid_update = true
        for val in update
            if isdisjoint(prev_numbers, get(rules, val, []))
                push!(prev_numbers, val)
            else
                valid_update = false
                break
            end
        end

        if !valid_update
            sorted_update = Int[]

            for val in update
                if isdisjoint(sorted_update, get(rules, val, []))
                    push!(sorted_update, val)
                else
                    pos = findfirst(e -> e ∈ rules[val], sorted_update)

                    insert!(sorted_update, pos, val)
                end
            end

            @debug "Sorted" sorted_update

            s += sorted_update[end ÷ 2 + 1]
        end
    end

    return s
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1)) == 123
    end
end

end # module Day05
