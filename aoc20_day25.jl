## Advent of Code 2020, Day 25
## https://adventofcode.com/2020/day/25
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

pubkey_card, pubkey_door = open("input/input25.txt", "r") do file
    parse.(Int, readlines(file))
end

function transform(sn, private_key, start_loop = 1, start_val = 1)
    val = start_val
    for it in start_loop:private_key
        val = (val * sn) % 20201227
    end
    val
end

function find_private_key(sn, public_key)
    private_key = 1
    val = 1
    while true
        val = transform(sn, private_key, private_key, val) 
        val == public_key && return(private_key)
        private_key += 1
    end
end

pk_card = find_private_key(7, pubkey_card)
solution_1 = transform(pubkey_door, pk_card) 

pk_door = find_private_key(7, pubkey_door)
solution_1b = transform(pubkey_card, pk_door)

## -- CHECK --
@assert solution_1 == solution_1b
check_answer(solution_1, 25, 1)