module Day03

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day03.input")
ans1_file = joinpath(DATA_DIR, "day03.ans1")
ans2_file = joinpath(DATA_DIR, "day03.ans2")

mul_regex = r"mul\((\d{1,3}),(\d{1,3})\)"

function parse_mul_match(regex_match)
    num1 = parse(Int, regex_match.captures[1])
    num2 = parse(Int, regex_match.captures[2])

    return num1 * num2
end

function star1(input=stdin)
    s = 0
    for line in eachline(input)
        for regex_match in eachmatch(mul_regex, line)
            s += parse_mul_match(regex_match)
        end
    end

    return s
end

hint1 = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 161
    end
end

do_regex = r"do\(\)"
dont_regex = r"don't\(\)"

function star2(input=stdin)
    s = 0
    disabled = false
    for line in eachline(input)
        @debug "Parsing" line

        index = 1
        while index != length(line)
            if disabled
                next_do = match(do_regex, line, index)

                if isnothing(next_do)
                    @debug "Found no more do"
                    break
                else
                    @debug "Found a do at" next_do.offset

                    index = next_do.offset + length(next_do)

                    disabled = false
                end
            else
                next_mul = match(mul_regex, line, index)
                next_dont = match(dont_regex, line, index)

                if isnothing(next_mul)
                    @debug "Found no more mul"
                    break
                elseif isnothing(next_dont) || next_mul.offset < next_dont.offset
                    @debug "Found mul first at" next_mul.offset, next_mul

                    s += parse_mul_match(next_mul)

                    index = next_mul.offset + length(next_mul)
                else
                    @debug "Found don't first at" next_dont.offset

                    index = next_dont.offset + length(next_dont)

                    disabled = true
                end
            end
        end

        @debug "Line done"
    end

    return s
end

hint2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint2)) == 48
    end
end

end # module Day03
