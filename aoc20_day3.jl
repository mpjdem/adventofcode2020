## Advent of Code 2020, Day 3
## https://adventofcode.com/2020/day/3
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input3.txt", "r") do file
    permutedims(hcat(collect.(readlines(file))...))
end

function move_tobbogan(pos::Array{Int, 1}, treemap::Array{Char, 2}, displacement::Array{Int, 1})::Array{Int, 1}
    newpos = pos + displacement
    newpos[2] = 1 + ((newpos[2] - 1) % size(treemap, 2))
    if newpos[1] > size(treemap, 1) Array{Int, 1}() else newpos end
end

function count_trees(pos::Array{Int, 1}, treemap::Array{Char, 2}, displacement::Array{Int, 1})::Int
    counter = 0
    while (!isempty(pos))
        if inp[pos...] == '#' counter += 1 end
        pos = move_tobbogan(pos, treemap, displacement)
    end
    counter
end

## -- PART 1 --
solution_1 = count_trees([1, 1], inp, [1, 3])

## -- PART 2 --
slopes = [[1, 1], [1, 3], [1, 5], [1, 7], [2, 1]] 
solution_2 = *(map(x -> count_trees([1, 1], inp, x), slopes)...)

## -- CHECK --
check_answer(solution_1, 3, 1)
check_answer(solution_2, 3, 2)