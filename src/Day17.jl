module Day17

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day17.input")
ans1_file = joinpath(DATA_DIR, "day17.ans1")
ans2_file = joinpath(DATA_DIR, "day17.ans2")

function parse_input(input)
    lines = Iterators.Stateful(eachline(input))

    reg_A = parse(Int, match(r"Register A: (\d+)", popfirst!(lines)).captures[1])
    reg_B = parse(Int, match(r"Register B: (\d+)", popfirst!(lines)).captures[1])
    reg_C = parse(Int, match(r"Register C: (\d+)", popfirst!(lines)).captures[1])

    popfirst!(lines)

    instr_match = match(r"Program: (\d(,\d)*)", popfirst!(lines))
    instructions = parse.(Int, split(instr_match.captures[1], ','))

    return reg_A, reg_B, reg_C, instructions
end

function show_program(instructions)
    return prod(Iterators.partition(instructions, 2)) do (opcode, operand)
        if 0 ≤ operand ≤ 3
            combo_operand = operand
        elseif operand == 4
            combo_operand = "A"
        elseif operand == 5
            combo_operand = "B"
        elseif operand == 6
            combo_operand = "C"
        else
            combo_operand = nothing
        end
        
        if opcode == 0
            return "adv $combo_operand   (A >> $combo_operand  -> A)\n"
        elseif opcode == 1
            return "bxl $operand   (B xor $operand -> B)\n"
        elseif opcode == 2
            return "bst $combo_operand   ($combo_operand mod 8 -> B)\n"
        elseif opcode == 3
            return "jnz $operand   (A != 0: jmp $operand)\n"
        elseif opcode == 4
            return "bxc     (B xor C -> B)\n"
        elseif opcode == 5
            return "out $combo_operand   ($combo_operand mod 8 -> out)\n"
        elseif opcode == 6
            return "bdv $combo_operand   (A >> $combo_operand  -> B)\n"
        elseif opcode == 7
            return "cdv $combo_operand   (A >> $combo_operand  -> C)\n"
        end
    end
end

function star1(input=stdin)
    reg_A, reg_B, reg_C, instructions = parse_input(input)
    
    @info "Program: \n$(show_program(instructions))"

    instruction_pointer = 0

    output = Int[]

    while instruction_pointer < length(instructions)
        opcode = instructions[instruction_pointer + 1]
        operand = instructions[instruction_pointer + 2]
        if 0 ≤ operand ≤ 3
            combo_operand = operand
        elseif operand == 4
            combo_operand = reg_A
        elseif operand == 5
            combo_operand = reg_B
        elseif operand == 6
            combo_operand = reg_C
        else
            combo_operand = nothing
        end

        if opcode == 0
            @debug "adv" operand, combo_operand

            reg_A = reg_A >> combo_operand

            instruction_pointer += 2
        elseif opcode == 1
            @debug "bxl" operand, combo_operand

            reg_B = reg_B ⊻ operand

            instruction_pointer += 2
        elseif opcode == 2
            @debug "bst" operand, combo_operand

            reg_B = combo_operand % 8

            instruction_pointer += 2
        elseif opcode == 3
            @debug "jnz" operand, combo_operand

            if reg_A == 0
                instruction_pointer += 2
            else
                instruction_pointer = operand
            end
        elseif opcode == 4
            @debug "bxc" operand, combo_operand

            reg_B = reg_B ⊻ reg_C

            instruction_pointer += 2
        elseif opcode == 5
            @debug "out" operand, combo_operand

            push!(output, combo_operand % 8)

            instruction_pointer += 2
        elseif opcode == 6
            @debug "bdv" operand, combo_operand

            reg_B = reg_A >> combo_operand

            instruction_pointer += 2
        elseif opcode == 7
            @debug "cdv" operand, combo_operand

            reg_C = reg_A >> combo_operand

            instruction_pointer += 2
        end
    end

    return output
end

hint1 = """
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    """

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == [4,6,3,5,6,3,5,2,1,0]
    end
end

function star2(input=stdin)
    _, init_reg_B, init_reg_C, instructions = parse_input(input)

    @info "Program: \n$(show_program(instructions))"

    function run_to_first_output(init_reg_A)
        instruction_pointer = 0
        reg_A = init_reg_A
        reg_B = init_reg_B
        reg_C = init_reg_C

        while instruction_pointer < length(instructions)
            opcode = instructions[instruction_pointer + 1]
            operand = instructions[instruction_pointer + 2]
            if 0 ≤ operand ≤ 3
                combo_operand = operand
            elseif operand == 4
                combo_operand = reg_A
            elseif operand == 5
                combo_operand = reg_B
            elseif operand == 6
                combo_operand = reg_C
            else
                combo_operand = nothing
            end

            if opcode == 0
                # adv
                reg_A = reg_A >> combo_operand

                instruction_pointer += 2
            elseif opcode == 1
                # bxl
                reg_B = reg_B ⊻ operand

                instruction_pointer += 2
            elseif opcode == 2
                # bst
                reg_B = combo_operand % 8

                instruction_pointer += 2
            elseif opcode == 3
                # jnz
                if reg_A == 0
                    instruction_pointer += 2
                else
                    instruction_pointer = operand
                end
            elseif opcode == 4
                # bxc
                reg_B = reg_B ⊻ reg_C

                instruction_pointer += 2
            elseif opcode == 5
                # out
                return combo_operand % 8

                instruction_pointer += 2
            elseif opcode == 6
                # bdv
                reg_B = reg_A >> combo_operand

                instruction_pointer += 2
            elseif opcode == 7
                # cdv
                reg_C = reg_A >> combo_operand

                instruction_pointer += 2
            end
        end
    end

    possible_top_bits = [0]

    for instr in reverse(instructions)
        new_possible_top_bits = Int[]

        for top_bits in possible_top_bits
            for new_bits in 0:7
                test_reg_A = (top_bits << 3) + new_bits

                program_out = run_to_first_output(test_reg_A)

                if program_out == instr
                    @debug "A: $(bitstring(top_bits))" program_out
                    push!(new_possible_top_bits, test_reg_A)
                end
            end
        end

        possible_top_bits = new_possible_top_bits
    end

    return first(possible_top_bits)
end

hint2 = """
    Register A: 2024
    Register B: 0
    Register C: 0

    Program: 0,3,5,4,3,0
    """

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint2)) == 117440
    end
end

end # module Day17
