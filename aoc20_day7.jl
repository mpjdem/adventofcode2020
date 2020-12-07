## Advent of Code 2020, Day 7
## https://adventofcode.com/2020/day/7
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

## Parse the input into a Look-Up Dictionary
lud = Dict()
open("input/input7.txt", "r") do file
    for ln in split.(readlines(file), " bags contain ")
        pat = r"[0-9]{1} [a-z]+ [a-z]+"
        push!(lud, split(ln[1], " ") => 
                   [split(x.match, " ") for x in eachmatch(pat, ln[2])])
    end
end

## -- PART 1 --
## Invert the look-up dictionary
invlud = Dict()
for ln in keys(lud), bags in lud[ln]
    push!(invlud, bags[2:3] => vcat(get(invlud, bags[2:3], []), [ln]))
end

## Recursively retrieve all the bags that can contain this one 
bagset = Set()
function retrieve_containers(bag)
    for x in get(invlud, bag, [])
        push!(bagset, x)
        retrieve_containers(x)
    end
end

retrieve_containers(["shiny", "gold"])
solution_1 = length(bagset)

## -- PART 2 --
## Given n bags of a type, how many do we have including all containees 
function add_containee_count(bag, n)
    res = n
    for x in lud[bag]
        new_n = add_containee_count(x[2:3], parse(Int, x[1])) 
        res += (n * new_n)
    end
    res
end

solution_2 = add_containee_count(["shiny", "gold"], 1) - 1

## -- CHECK --
check_answer(solution_1, 7, 1)
check_answer(solution_2, 7, 2)