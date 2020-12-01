## Advent of Code 2020, Day 1
## https://adventofcode.com/2020/day/1
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input1.txt", "r") do file
    parse.(Int, readlines(file))
end

## -- PART 1 --
solution_1 = 0
for i in inp, j in inp
    if i + j == 2020
        solution_1 = i * j
        break
    end
end

check_answer(solution_1, 1, 1)

## -- PART 2 --
solution_2 = 0
for i in inp, j in inp, k in inp
    if i + j + k == 2020
        solution_2 = i * j * k
        break
    end
end

check_answer(solution_2, 1, 2)