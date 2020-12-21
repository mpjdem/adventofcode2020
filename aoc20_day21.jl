## Advent of Code 2020, Day 21 
## https://adventofcode.com/2020/day/21
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

struct IngredientList
    ingredients::Set{String}
    allergens::Set{String}
end

inp = open("input/input21.txt", "r") do file
    map(ln -> IngredientList(Set(split(match(r"[a-z, ]+(?= \()", ln).match, " ")),
                             Set(split(match(r"(?<=contains )[a-z, ]+", ln).match, ", "))),
        readlines(file))
end

## -- PART 1 --
## Narrow down allergen => potential ingredients
## Then remove the remaining candidates from the ingredient lists
d = Dict()
for il in inp
    for al in il.allergens
        if al in keys(d) d[al] = intersect(d[al], il.ingredients)
        else d[al] = il.ingredients 
        end
    end
end

all_allergens = union(values(d)...)
all_ingredients = vcat([collect(setdiff(il.ingredients, all_allergens)) for il in inp]...)
solution_1 = length(all_ingredients)

## -- PART 2 --
## For each allergen we've 100% determined, remove it as a candidate for others
## Until we have determined every allergen
while true
    local allergens = collect(values(d))
    al_n = length.(allergens)
    if all(al_n .== 1) break end
    for idx in findall(al_n .== 1)
        determined = allergens[idx]
        for k in setdiff(keys(d), Set([collect(keys(d))[idx]]))
            d[k] = setdiff(d[k], determined) 
        end
    end
end

pl = sort(collect(d), by = x -> x[1])
solution_2 = join([collect(p[2])[1] for p in pl], ",")

## -- CHECK --
check_answer(solution_1, 21, 1)
check_answer(solution_2, 21, 2)