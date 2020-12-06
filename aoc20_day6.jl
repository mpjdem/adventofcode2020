## Advent of Code 2020, Day 6
## https://adventofcode.com/2020/day/6
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input6.txt", "r") do file
    split.(join(readlines(file), " "), "  ")
end

## -- PART 1 --
solution_1 = sum(map(x -> length(setdiff(x, [" "])), 
                     split.(inp, "")))

## -- PART 2 --
solution_2 = sum(map(x -> length(intersect(split.(x, "")...)), 
                     split.(inp, " ")))

## -- CHECK --
check_answer(solution_1, 6, 1)
check_answer(solution_2, 6, 2)