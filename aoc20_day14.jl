## Advent of Code 2020, Day 14
## https://adventofcode.com/2020/day/14
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

struct Instruction 
    bitmask::BitArray{1}
    xmask::BitArray{1}
    memints::Array{Tuple{Int,Int}, 1}
end

instructions = open("input/input14.txt", "r") do file
    lns = readlines(file)
    instructions = Array{Instruction, 1}(undef, 0)
    bitmask = BitArray{1}(undef, 0)
    xmask = BitArray{1}(undef, 0)
    memints = Array{Tuple{Int, Int}, 1}(undef, 0)
    for ln in lns
        if startswith(ln, "mask")
            if !isempty(memints) 
                push!(instructions, Instruction(bitmask, xmask, memints))
            end
            maskarr = reverse(split(match(r"mask = ([0X1]+)", ln)[1], ""))
            bitmask = maskarr .== "1"
            xmask = maskarr .== "X"
            memints = Array{Tuple{Int, Int}, 1}(undef, 0)
        else
            ints = parse.(Int, [x.match for x in eachmatch(r"([0-9]+)", ln)])
            push!(memints, Tuple(ints))
        end 
    end
    push!(instructions, Instruction(bitmask, xmask, memints))
    instructions
end

function int2bit(x::Int, pad::Int)::BitArray{1}
    digits(x, base = 2, pad = pad) .== 1
end

function bit2int(x::BitArray{1})::Int
    sum((2 .^ (0:(length(x) - 1))) .* x)
end

## -- PART 1 --
masksz = length(instructions[1].bitmask)
addresses = Dict()
for instr in instructions, memint in instr.memints
    bval = int2bit(memint[2], masksz)
    bval[.!instr.xmask] = instr.bitmask[.!instr.xmask]
    addresses[memint[1]] = bit2int(bval)
end

solution_1 = sum(values(addresses))

## -- PART 2 --
## Floating bit combinations are generated as 1:2^nbits in binary
addresses = Dict()
for instr in instructions, memint in instr.memints
    y = int2bit(memint[1], masksz)
    nbits = sum(instr.xmask)
    for floatint in 0:(2^nbits - 1)
        floatbits = int2bit(floatint, nbits)
        y[instr.xmask] = floatbits
        y[instr.bitmask] .= true 
        addresses[bit2int(y)] = memint[2]
    end
end

solution_2 = sum(values(addresses))

## -- CHECK --
check_answer(solution_1, 14, 1)
check_answer(solution_2, 14, 2)