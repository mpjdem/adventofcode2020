## Advent of Code 2020, Day 16
## https://adventofcode.com/2020/day/16
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input16.txt", "r") do file
    readlines(file)
end

breakidxs = findall(inp .== "")

fields = Dict()
for ln in inp[1:breakidxs[1]-1]
    k = split(ln, ": ")[1]
    v = parse.(Int, [x.match for x in eachmatch(r"([0-9]+)", ln)])
    fields[k] = (v[1]:v[2], v[3]:v[4])
end

your_ticket = parse.(Int, split(inp[breakidxs[1] + 2], ","))

nearby_tickets = map(ln -> parse.(Int, split(ln, ",")),
                     inp[(breakidxs[2]+2):end])

## -- PART 1 --
invalid_values = []
for val in vcat(nearby_tickets...)
    if all([val ∉ tr[1] && val ∉ tr[2] for tr in values(fields)])
        push!(invalid_values, val) 
    end
end

solution_1 = sum(invalid_values)

## -- PART 2 --
valid_tickets = nearby_tickets[map(ticket -> all([t ∉ invalid_values for t in ticket]), 
                                   nearby_tickets)]
solve_arr = [[] for i in 1:20]

## First determine which fields could possibly be valid for a given position
for pos = 1:length(solve_arr)
    vals_at_pos = map(x -> x[pos], vcat(valid_tickets, [your_ticket]))
    for fld = keys(fields)
        if all([v ∈ fields[fld][1] || v ∈ fields[fld][2] for v = vals_at_pos])
            solve_arr[pos] = vcat(solve_arr[pos], [fld]) 
        end 
    end
end

## Then work it out starting with the position with only one alternative
count_alt = [length(v) for v in solve_arr]
determined = []
solution_vals = []
for n_alt = 1:length(solve_arr) 
    pos = findfirst(count_alt .== n_alt)
    solve_arr[pos] = setdiff(solve_arr[pos], determined)
    if startswith(only(solve_arr[pos]), "departure")
        push!(solution_vals, your_ticket[pos])
    end
    push!(determined, only(solve_arr[pos]))
end

solution_2 = prod(solution_vals)

## -- CHECK --
check_answer(solution_1, 16, 1)
check_answer(solution_2, 16, 2)