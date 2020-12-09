## Advent of Code 2020, Day 9
## https://adventofcode.com/2020/day/9
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input9.txt", "r") do file
    parse.(Int, readlines(file))
end

## -- PART 1 --
function validate_number(vec::Array{Int, 1}, nprev::Int, idx::Int)::Bool
    for i in 0:(nprev - 1), j in 0:(nprev - 1)
        if vec[idx - nprev + i] + vec[idx - nprev + j] == vec[idx] && i != j
            return(true) 
        end 
    end
    return(false)
end

first_invalid_idx = nothing
for idx in 26:length(inp)
    if validate_number(inp, 25, idx) == false
        global first_invalid_idx = idx
        break
    end
end 

solution_1 = inp[first_invalid_idx]

## -- PART 2 --
## Shortcuts to brute-forcing:
##   - Start backward from the index of solution_1
##   - Increase window size, breaking when the target number is exceeded
solution_2 = nothing
for stopidx in (first_invalid_idx - 1):-1:1 
    for start_offset in 1:(stopidx - 1)
        wdw = (stopidx - start_offset):stopidx
        summed = sum(inp[wdw])
        if summed == solution_1
            global solution_2 = maximum(inp[wdw]) + minimum(inp[wdw])
            break
        elseif summed > solution_1
            break
        end
    end
    if !isnothing(solution_2) break end
end

## -- CHECK --
check_answer(solution_1, 9, 1)
check_answer(solution_2, 9, 2)