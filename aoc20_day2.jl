## Advent of Code 2020, Day 2
## https://adventofcode.com/2020/day/2
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

struct PasswordPolicy
    first_n::Int
    second_n::Int
    chr::Char
end

function parse_lines(ln::String)::Array{Any, 1}

    str_parts = split(ln, ['-', ' ', ':'])

    Any[
        PasswordPolicy(
            parse(Int, str_parts[1]),
            parse(Int, str_parts[2]),
            first(str_parts[3])
        ),
        string(str_parts[5])
     ]

end

inp = open("input/input2.txt", "r") do file
    parse_lines.(readlines(file))
end

## -- PART 1 --
function validate_password_1(pol::PasswordPolicy, pw::String)::Bool
    found_n = count(c -> (c == pol.chr), pw)
    found_n >= pol.first_n && found_n <= pol.second_n
end

solution_1 = sum(map(pln -> validate_password_1(pln[1], pln[2]), inp))

check_answer(solution_1, 2, 1)

## -- PART 2 --
function validate_password_2(pol::PasswordPolicy, pw::String)::Bool
    xor(pw[pol.first_n] == pol.chr, pw[pol.second_n] == pol.chr)
end

solution_2 = sum(map(pln -> validate_password_2(pln[1], pln[2]), inp))

check_answer(solution_2, 2, 2)
