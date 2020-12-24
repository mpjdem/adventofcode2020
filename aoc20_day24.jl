## Advent of Code 2020, Day 24
## https://adventofcode.com/2020/day/24
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input24.txt", "r") do file
    map(ln -> [ln[idx] for idx in findall(r"((s|n)(e|w)|(e|w))", ln)], 
        readlines(file))
end

## -- PART 1 --
function dirs2pos(dirs)
    pos = [0, 0]
    for d in dirs
       if d == "e" pos .+= [1, 0]
       elseif d == "w" pos .+= [-1, 0]
       elseif d == "se" pos .+= [1, -1]
       elseif d == "nw" pos .+= [-1, 1]
       elseif d == "ne" pos .+= [0, 1]
       elseif d == "sw" pos .+= [0, -1]
       end
    end
    pos
end

tiles = Dict()
for tile in inp
    pos = dirs2pos(tile)
    tiles[pos] = 1 - get(tiles, pos, 1)
end

solution_1 = sum(values(tiles) .== 0)

## -- PART 2 --
function get_neighbours(pos)
    nb = [[1, 0], [0, 1], [-1, 0], [0, -1], [-1, 1], [1, -1]]
    [pos .+ relpos for relpos in nb]
end

function one_day!(tiles) 
    current = copy(tiles)
    known_tiles = collect(keys(current))
    new_tiles = setdiff(vcat([get_neighbours(pos) for pos in known_tiles]...), known_tiles)
    for pos in vcat(known_tiles, new_tiles)
        col = get(current, pos, 1)
        n_white = sum([get(current, nbpos, 1) for nbpos in get_neighbours(pos)])
        if col == 1 && n_white == 4
            tiles[pos] = 0
        elseif col == 0 && n_white ∈ [0, 1, 2, 3, 6]
            tiles[pos] = 1
        end
    end
end

for day in 1:100 one_day!(tiles) end
solution_2 = sum(values(tiles) .== 0)

## -- CHECK --
check_answer(solution_1, 24, 1)
check_answer(solution_2, 24, 2)