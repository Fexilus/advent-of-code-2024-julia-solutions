module Day02

using Test
using Logging

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day02.input")
ans1_file = joinpath(DATA_DIR, "day02.ans1")
ans2_file = joinpath(DATA_DIR, "day02.ans2")

parse_report(line) = parse.(Int, split(line))

function star1(input=stdin)
    return sum(eachline(input)) do line
        report = parse_report(line)

        dec = all(d -> (1 ≤ d ≤ 3), diff(report))
        inc = all(d -> (-3 ≤ d ≤ -1), diff(report))

        @debug "" report, dec, inc

        if dec || inc
            return 1
        else
            return 0
        end
    end
end

hint1 = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 2
    end
end

function safe_report_old_old(report; dampener=true)
    cur_num = first(report)

    skipped_num = !dampener

    increasing = true
    for new_num in Iterators.drop(report, 1)
        if 1 ≤ new_num - cur_num ≤ 3
            cur_num = new_num
        elseif !skipped_num
            skipped_num = true
            continue
        else
            increasing = false
            break
        end
    end
    
    cur_num = first(report)

    skipped_num = !dampener

    decreasing = true
    for new_num in Iterators.drop(report, 1)
        if -3 ≤ new_num - cur_num ≤ -1
            cur_num = new_num
        elseif !skipped_num
            skipped_num = true
            continue
        else
            decreasing = false
            break
        end
    end

    @debug "" report, increasing, decreasing

    return increasing || decreasing
end

function safe_report_old(report; dampener=true)

    is_valid_inc(d) = (-3 ≤ d ≤ -1)

    if all(is_valid_inc, diff(report))
        increasing = true
    else
        first_error = findfirst(!is_valid_inc, diff(report))

        if all(is_valid_inc, diff(report[1:end .!= first_error]))
            increasing = true
        elseif all(is_valid_inc, diff(report[1:end-1]))
            increasing = true
        else
            increasing = false
        end
    end
    
    is_valid_dec(d) = (1 ≤ d ≤ 3)
    
    if all(is_valid_dec, diff(report))
        decreasing = true
    else
        first_error = findfirst(!is_valid_dec, diff(report))

        if all(is_valid_dec, diff(report[1:end .!= first_error]))
            decreasing = true
        elseif all(is_valid_dec, diff(report[1:end-1]))
            decreasing = true
        else
            decreasing = false
        end
    end

    if !(increasing || decreasing)
        @debug "Diff" diff(report)
        @debug "Results" increasing, decreasing
    end
    
    return increasing || decreasing
end

function safe_report(report; dampener=true)

    is_valid_inc(d) = (-3 ≤ d ≤ -1)
    increasing = false

    if all(is_valid_inc, diff(report))
        increasing = true
    elseif dampener
        for k in 1:length(report)
            if all(is_valid_inc, diff(report[1:end .!= k]))
                increasing = true
                break
            end
        end
    end
    
    is_valid_dec(d) = (1 ≤ d ≤ 3)
    decreasing = false

    if all(is_valid_dec, diff(report))
        decreasing = true
    elseif dampener
        for k in 1:length(report)
            if all(is_valid_dec, diff(report[1:end .!= k]))
                decreasing = true
                break
            end
        end
    end

    if !(increasing || decreasing)
        @debug "Diff" diff(report)
        @debug "Results" increasing, decreasing
    end
    
    return increasing || decreasing
end

function star2(input=stdin)
    return sum(eachline(input)) do line
        report = parse_report(line)

        if safe_report(report)
            return 1
        else
            return 0
        end
    end
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1)) == 4
    end
end

end # module Day02
