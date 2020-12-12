## Advent of Code 2020, Day 12
## https://adventofcode.com/2020/day/12
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input12.txt", "r") do file
   map(x -> (string(x[1]), parse(Int, x[2:end])),
       readlines(file))
end

struct WaterObject
    x::Int
    y::Int
    or::Int
end

function move_ship(wo::WaterObject, instr::Tuple{String, Int})::WaterObject
    mv_rot_dirs = 
         Dict("F" => (wo.or, 0),
              "N" => (90, 0), "E" => (0, 0), "S" => (270, 0), "W" => (180, 0),
              "R" => (nothing, -1), "L" => (nothing, 1))
    if !isnothing(mv_rot_dirs[instr[1]][1])
        mvdir = deg2rad(mv_rot_dirs[instr[1]][1])
        x = wo.x + instr[2] * round(cos(mvdir))
        y = wo.y + instr[2] * round(sin(mvdir))
    else
        x = wo.x; y = wo.y
    end
    rotdir = mv_rot_dirs[instr[1]][2]
    or = mod(wo.or + rotdir * instr[2], 360)
    WaterObject(x, y, or)
end

## -- PART 1 --
ship = WaterObject(0, 0, 0)
for instr in inp
    global ship = move_ship(ship, instr)
end

solution_1 = abs(ship.x) + abs(ship.y)

## -- PART 2--
function move_wp(wo::WaterObject, instr::Tuple{String, Int})
    if instr[1] in ["N", "E", "S", "W"]
        move_ship(wo, instr)
    else
        rot_dirs = Dict("R" => -1, "L" => 1)
        rot = rot_dirs[instr[1]] * deg2rad(instr[2])
        x = round(wo.x * cos(rot) - wo.y * sin(rot))
        y = round(wo.y * cos(rot) + wo.x * sin(rot))
        WaterObject(x, y, wo.or)
    end
end

wp = WaterObject(10, 1, 0)
ship = WaterObject(0, 0, 0)
for instr in inp
    if instr[1] == "F"
        x = ship.x + instr[2] * wp.x
        y = ship.y + instr[2] * wp.y
        global ship = WaterObject(x, y, ship.or)
    else
        global wp = move_wp(wp, instr)
    end
end

solution_2 = abs(ship.x) + abs(ship.y)

## -- CHECK --
check_answer(solution_1, 12, 1)
check_answer(solution_2, 12, 2)