## Advent of Code 2020, Day 15
## https://adventofcode.com/2020/day/15
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input15.txt", "r") do file
    parse.(Int, split(readline(file), ","))
end

function play_game(startseq::Array{Int, 1}, nrounds::Int)::Int
    history = Dict()
    number = 0; lastpos = 0
    for i in 1:nrounds
        if i <= length(startseq)
            number = startseq[i]
        elseif lastpos > 0
            number = i - 1 - lastpos
        else
            number = 0
        end
        lastpos = number in keys(history) ? history[number] : -1
        history[number] = i
    end
    number
end

solution_1 = play_game(inp, 2020)
solution_2 = play_game(inp, 30000000)

check_answer(solution_1, 15, 1)
check_answer(solution_2, 15, 2)
