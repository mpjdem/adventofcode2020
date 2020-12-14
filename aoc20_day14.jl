## Advent of Code 2020, Day 11
## https://adventofcode.com/2020/day/11
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

struct Instruction 
    bitmask::String
    memints::Array{Tuple{Int,Int}, 1}
end

inp = open("input/input14.txt", "r") do file
    lns = readlines(file)
    instructions = Array{Instruction, 1}(undef, 0)
    bitmask = ""
    memints = Array{Tuple{Int, Int}, 1}(undef, 0)
    for ln in lns
        if startswith(ln, "mask")
            if !isempty(memints) 
                push!(instructions, Instruction(bitmask, memints))
            end
            bitmask = split(ln, " = ")[2]
            memints = Array{Tuple{Int, Int}, 1}(undef, 0)
        else
            tmp = split(ln, ['[', ']', ' ', '='])
            push!(memints, (parse(Int, tmp[2]), parse(Int, tmp[6])))
        end 
    end
    push!(instructions, Instruction(bitmask, memints))
    instructions
end

## -- PART 1 --
addresses = Dict()
for instr in inp, memint in instr.memints
    int_as_bits = digits(memint[2], base = 2, pad = length(instr.bitmask))
    bm_as_arr = reverse(split(instr.bitmask, ""))
    for j in 1:length(bm_as_arr)
        if bm_as_arr[j] == "1"
            int_as_bits[j] = 1
        elseif bm_as_arr[j] == "0"
            int_as_bits[j] = 0
        end
    end
    addresses[memint[1]] = sum((2 .^ (0:(length(instr.bitmask) - 1))) .* int_as_bits)
end

solution_1 = sum(values(addresses))

## -- PART 2 --
addresses = Dict()
for instr in inp, memint in instr.memints
    maddr_as_bits = digits(memint[1], base = 2, pad = length(instr.bitmask))
    bm_as_arr = reverse(split(instr.bitmask, ""))
    xidx = findall(bm_as_arr .== "X")
    bm_as_arr = reshape(repeat(bm_as_arr, 2^length(xidx)), 
                        length(instr.bitmask), 2^length(xidx))
    for repi in 0:(size(bm_as_arr)[2] - 1)
        replbits = digits(repi, base = 2, pad = length(xidx))
        macp = copy(maddr_as_bits)
        macp[xidx] = replbits
        macp[bm_as_arr[:, repi + 1] .== "1"] .= 1
        ma_int = sum((2 .^ (0:(length(instr.bitmask) -1 ))) .* macp)
        addresses[ma_int] = memint[2]
    end
end

solution_2 = sum(values(addresses))

## -- CHECK --
check_answer(solution_1, 14, 1)
check_answer(solution_2, 14, 2)
