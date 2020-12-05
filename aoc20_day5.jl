## Advent of Code 2020, Day 5
## https://adventofcode.com/2020/day/5
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input5.txt", "r") do file
    readlines(file)
end

struct BoardingPass
    row::Int
    column::Int
    seatid::Int
end

function subcode_to_int(subcode::String, compareto::String)::Int
    convert(Int, reverse!((split(subcode, "") .== compareto)).chunks[1])
end

function BoardingPass(seatcode::String)::BoardingPass
    row = subcode_to_int(seatcode[1:7], "B")
    col = subcode_to_int(seatcode[8:10], "R")
    BoardingPass(row, col, (row * 8) + col)
end

## -- PART 1 --
all_seatids = map(x -> BoardingPass(x).seatid, inp)
solution_1 = maximum(all_seatids)

## -- PART 2 --
sort!(all_seatids)
solution_2 = all_seatids[findall(x -> x == 2, diff(all_seatids))[1]] + 1

## -- CHECK --
check_answer(solution_1, 5, 1)
check_answer(solution_2, 5, 2)