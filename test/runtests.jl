using Test
using Logging

using AdventOfCode2024

day_modules = [
    Day01,
    Day02,
    Day03,
    Day04,
    Day05,
    Day06,
    Day07,
    Day08,
    Day09,
    Day10,
    Day11,
    Day12,
    Day13,
    Day14,
    Day15,
    Day16,
    Day17,
    Day18,
    Day19,
    Day20,
    Day21,
    Day22,
    Day23,
    Day24,
    Day25,
]

module_name(Mod) = last(rsplit(repr("text/plain", Mod), "."; limit=2))

with_logger(ConsoleLogger(Logging.Warn)) do
    @testset "AdventOfCode2024" begin
        @testset "$(module_name(DayModule))" for DayModule in day_modules
            DayModule.test_hints_star1()
            DayModule.test_hints_star2()

            @testset "Solutions" begin
                if ispath(DayModule.input_file) && ispath(DayModule.ans1_file)
                    @test string(DayModule.star1(DayModule.input_file)) == readline(DayModule.ans1_file)
                else
                    @test_skip string(DayModule.star1(DayModule.input_file)) == readline(DayModule.ans1_file)
                end

                if ispath(DayModule.input_file) && ispath(DayModule.ans2_file)
                    @test string(DayModule.star2(DayModule.input_file)) == readline(DayModule.ans2_file)
                else
                    @test_skip string(DayModule.star2(DayModule.input_file)) == readline(DayModule.ans2_file)
                end
            end
        end
    end
end
