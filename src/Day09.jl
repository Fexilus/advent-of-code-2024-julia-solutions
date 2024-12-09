module Day09

using Test

using ..Utils: DATA_DIR

export input_file
export star1
export test_hints_star1
export ans1_file
export star2
export test_hints_star2
export ans1_file

input_file = joinpath(DATA_DIR, "day09.input")
ans1_file = joinpath(DATA_DIR, "day09.ans1")
ans2_file = joinpath(DATA_DIR, "day09.ans2")

function star1(input=stdin)
    line = readline(input)

    cur_id = 0
    cur_pos = 0
   
    cur_tail = Int[]
    tail_index = length(line) + 2
    if iseven(tail_index)
        tail_index -= 1
    end

    s = 0
    for m in eachmatch(r"(\d)(\d)", line)

        if m.offset == tail_index
            break
        end

        block_size = parse(Int, m.captures[1])
        space_size = parse(Int, m.captures[2])

        new_pos = cur_pos + block_size

        for pos in cur_pos:(new_pos - 1)
            s += pos * cur_id
        end

        cur_pos = new_pos

        new_pos = cur_pos + space_size
        
        for pos in cur_pos:(new_pos - 1)
            while isempty(cur_tail)
                tail_index -= 2
                tail_id = tail_index ÷ 2
                
                tail_block_size = parse(Int, line[tail_index])

                for i in 1:tail_block_size
                    push!(cur_tail, tail_id)
                end  
            end

            s += pos * pop!(cur_tail)
        end

        cur_pos = new_pos

        cur_id += 1
    end

    new_pos = cur_pos + length(cur_tail)

    for pos in cur_pos:(new_pos - 1)
        s += pos * pop!(cur_tail)
    end

    return s
end

hint1 = "2333133121414131402"

function test_hints_star1()
    @testset "Star 1 hints" begin
        @test star1(IOBuffer(hint1)) == 1928
    end
end

function star2(input=stdin)
    line = readline(input)

    sizes = parse.(Int, c for c in line)
    positions = insert!(cumsum(sizes), 1, 0)

    ids = 0:((length(line) + 1) ÷ 2)
    block_sizes = sizes[1:2:end]
    block_positions = positions[1:2:end]

    blocks = collect(zip(ids, block_sizes, block_positions))

    space_sizes = sizes[2:2:end]
    space_positions = positions[2:2:end]

    spaces = collect(zip(space_sizes, space_positions))
    push!(spaces, (typemax(Int), positions[end]))

    moved_blocks = Set()

    s = 0
    for (block, space) in zip(blocks, spaces)
        if block in moved_blocks
            @debug "Skipping" block
        else
            @debug "Forward block" block

            (block_id, block_size, block_pos) = block

            for pos in block_pos:(block_pos + block_size - 1)
                s += pos * block_id
            end
        end

        (space_size, space_pos) = space

        for tail_block in reverse(blocks)
            if tail_block == block
                break
            elseif tail_block in moved_blocks
                continue
            end

            (block_id, block_size, _) = tail_block

            if block_size ≤ space_size
                @debug "Moving block" tail_block

                push!(moved_blocks, tail_block)

                for pos in space_pos:(space_pos + block_size - 1)
                    s += pos * block_id
                end

                space_size -= block_size
                space_pos += block_size
            end
        end
    end

    return s
end

function test_hints_star2()
    @testset "Star 2 hints" begin
        @test star2(IOBuffer(hint1)) == 2858
    end
end

end # module Day09
