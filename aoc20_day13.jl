## Advent of Code 2020, Day 13
## https://adventofcode.com/2020/day/13
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input13.txt", "r") do file
    readlines(file) 
end

## -- PART 1 --
timestamp = parse(Int, inp[1])
timetable = split(inp[2], ",")
bus_offsets = findall(.!(timetable .== "x"))
bus_ids = parse.(Int, timetable[bus_offsets])

ts_offsets = bus_ids .- rem.(timestamp, bus_ids)
solution_1 = minimum(ts_offsets) * bus_ids[argmin(ts_offsets)]

## -- PART 2 --
## Add the buses one by one, each time determining periodicity
## And searching forward using that new step size
buses = [(bus_offsets[i] - 1, bus_ids[i]) for i in 1:length(bus_ids)]
periodicity = buses[1][2]
timestamp = buses[1][1]
for bus in buses[2:end]
    while ((timestamp + bus[1]) % bus[2]) != 0
        global timestamp = timestamp + periodicity
    end
    global periodicity = periodicity * bus[2] 
end

solution_2 = timestamp

## -- CHECK --
check_answer(solution_1, 13, 1)
check_answer(solution_2, 13, 2)
