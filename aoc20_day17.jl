## Advent of Code 2020, Day 17
## https://adventofcode.com/2020/day/17
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

using DataFrames
using DataFramesMeta

inp = open("input/input17.txt", "r") do file

    lns = readlines(file)
    vals = vcat(split.(lns, "")...) .== "#"
    sz = convert(Int, sqrt(length(vals)))

    DataFrame(x = repeat(1:sz, sz),
              y = repeat(1:sz, inner = sz),
              z = 0,
              w = 0,
              val = vals)
end

function tick(universe, neighbourhood)

    ## Expand universe
    expansion = 
        crossjoin(DataFrame(x = [minimum(universe.x) - 1, unique(universe.x)..., maximum(universe.x) + 1]),
                  DataFrame(y = [minimum(universe.y) - 1, unique(universe.y)..., maximum(universe.y) + 1]),
                  DataFrame(z = [minimum(universe.z) - 1, unique(universe.z)..., maximum(universe.z) + 1]),
                  DataFrame(w = [minimum(universe.w) - 1, unique(universe.w)..., maximum(universe.w) + 1]))

    universe = @linq leftjoin(expansion, universe, on = [:x, :y, :z, :w]) |>
                     transform(val = map(v -> ismissing(v) ? false : v, :val))

    ## Join with neighbours and count the active ones 
    nbs = @linq crossjoin(universe, neighbourhood) |> 
                transform(nx = :x .+ :dx,
                          ny = :y .+ :dy,
                          nz = :z .+ :dz,
                          nw = :w .+ :dw) |>
                select(:x, :y, :z, :w, :nx, :ny, :nz, :nw)

    nnbs = @linq innerjoin(nbs, universe, on = [:nx => :x, :ny => :y, :nz => :z, :nw => :w]) |>
                 by([:x, :y, :z, :w], nnb = sum(:val))

    ## Change status according the laws of the universe
    universe = @linq innerjoin(universe, nnbs, on = [:x, :y, :z, :w]) |>
                     transform(val = (:val .& ((:nnb .== 2) .| (:nnb .== 3))) .| ((.!(:val)) .& (:nnb .== 3))) |>
                     select(:x, :y, :z, :w, :val) 
    
    ## Return
    universe

end

## -- PART 1 --
u1  = copy(inp)
nb1 = @linq crossjoin(DataFrame(dx = [-1, 0, 1]),
                      DataFrame(dy = [-1, 0, 1]),
                      DataFrame(dz = [-1, 0, 1]),
                      DataFrame(dw = [0])) |>
            where((:dx .!= 0) .| (:dy .!= 0) .| (:dz .!= 0))

for i in 1:6 global u1 = tick(u1, nb1) end

solution_1 = sum(u1.val)

## -- PART 2 --
u2 = copy(inp)

nb2 = @linq crossjoin(DataFrame(dx = [-1, 0, 1]),
                      DataFrame(dy = [-1, 0, 1]),
                      DataFrame(dz = [-1, 0, 1]),
                      DataFrame(dw = [-1, 0, 1])) |>
            where((:dx .!= 0) .| (:dy .!= 0) .| (:dz .!= 0) .| (:dw .!= 0))

for i in 1:6 global u2 = tick(u2, nb2) end

solution_2 = sum(u2.val)

## -- CHECk --
check_answer(solution_1, 17, 1)
check_answer(solution_2, 17, 2)