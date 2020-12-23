## Advent of Code 2020, Day 23
## https://adventofcode.com/2020/day/23
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input23.txt", "r") do file
    parse.(Int, split(readline(file), ""))
end

## Store cups as a dictionary of cup => next_cup
## And only change entries affected by the round
function play_cups(cups, nrounds)
    d = Dict(zip(cups, vcat(cups[2:end], cups[1])))
    cur = cups[1]
    for roundn in 1:nrounds
        picked_up = [d[cur], d[d[cur]], d[d[d[cur]]]]
        d[cur] = d[picked_up[3]]
        dest = cur - 1
        while dest ∈ picked_up || dest == 0
            dest = dest - 1
            if dest <= 0 dest = length(cups) end 
        end
        d[picked_up[3]] = d[dest]
        d[dest] = picked_up[1] 
        cur = d[cur]
    end
    d
end

## -- PART 1 --
cups = copy(inp)
res = play_cups(cups, 100)
vec = []
cup = res[1]
while cup != 1 
    append!(vec, cup)
    global cup = res[cup]
end
solution_1 = join(vec)

## -- PART 2 --
cups = vcat(copy(inp), (maximum(inp) + 1):1000000)
res = play_cups(cups, 10000000)
solution_2 = res[1] * res[res[1]]

## -- CHECK --
check_answer(solution_1, 23, 1)
check_answer(solution_2, 23, 2)