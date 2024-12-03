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

function star1(input=stdin)
    s = 0
    for line in eachline(input)
        for regex_match in eachmatch(mul_regex, line)
            num1 = parse(Int, regex_match.captures[1])
            num2 = parse(Int, regex_match.captures[2])
            s += num1 * num2
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
        @info "$line"
        index = 1
        while index != length(line)
            if disabled
                next_do = match(do_regex, line, index)

                if isnothing(next_do)
                    @info "Found no more do"
                    break
                else
                    @info "Found a do" next_do
                    index = next_do.offset + length(next_do)
                    disabled = false
                end
            else
                next_mul = match(mul_regex, line, index)
                next_dont = match(dont_regex, line, index)

                if isnothing(next_mul)
                    @info "Line done"
                    break
                elseif isnothing(next_dont) || next_mul.offset < next_dont.offset
                    @info "Found mul first" next_mul
                    num1 = parse(Int, next_mul.captures[1])
                    num2 = parse(Int, next_mul.captures[2])
                    s += num1 * num2

                    index = next_mul.offset + length(next_mul)
                else
                    @info "Found don't first" next_dont
                    index = next_dont.offset + length(next_dont)
                    disabled = true
                end
            end
        end
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
