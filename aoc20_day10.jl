## Advent of Code 2020, Day 10
## https://adventofcode.com/2020/day/10
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

using StatsBase

inp = open("input/input10.txt", "r") do file
    parse.(Int, readlines(file))
end

## -- PART 1 --
diffs = diff(vcat([0], sort(inp), [maximum(inp) + 3]))
solution_1 = sum(diffs .== 1) * sum(diffs .== 3)

## -- PART 2 --
## Consider only the combinations of sequences that could be changed
## Knowing that diffs is always in (1,3) and runs of 1s are max 4
runs = rle(diffs)

solution_2 = 
    2 ^ sum((runs[1] .== 1) .& (runs[2] .== 2)) * 
    4 ^ sum((runs[1] .== 1) .& (runs[2] .== 3)) * 
    7 ^ sum((runs[1] .== 1) .& (runs[2] .== 4))

## -- CHECK --
check_answer(solution_1, 10, 1)
check_answer(solution_2, 10, 2)