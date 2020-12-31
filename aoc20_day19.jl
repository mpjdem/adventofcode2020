## Advent of Code 2020, Day 19
## https://adventofcode.com/2020/day/19
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

rules = Dict()
targets = []

open("input/input19.txt", "r") do file
    
    lns = readlines(file)
    breakln = findall(lns .== "")[1]
    
    for ln in lns[1:(breakln - 1)]
        (rulenr, rule) = split(ln, ": ")                    
        subrules = split(rule, " | ")
        val = 
            map(sr -> begin
                    if contains(sr, r"^[0-9 ]+$")
                        parse.(Int, split(sr, " "))
                    else
                        [string(sr[2])]
                    end
                end, subrules)
        rules[parse(Int, rulenr)] = val 
    end
    
    for ln in lns[(breakln+1):end] 
        push!(targets, ln) 
    end

end

## Recursively build a regex
## For Part 2 put in placeholder text if the rule refers to itself,
## after each sr_part of the regex, and remove that subrule.
function solve_rule(rules, rulenr)

    subrules = rules[rulenr]
    repeat_components = false

    resv = 
        map(sr -> begin
                if rulenr ∈ sr 
                    repeat_components = true
                    nothing 
                else
                     map(sr_part -> begin
                            if isa(sr_part, Int)
                                solve_rule(rules, sr_part)
                            else
                                sr_part
                            end
                        end, sr)
                end
            end, subrules)

    resv = filter(x -> !isnothing(x), resv)
    suffix = repeat_components ? "N$rulenr" : "" 

    res = join(map(sr -> join(map(srp -> "$srp$suffix", sr)), 
                   resv), 
               "|")
    
    if contains(res, r"\|") res = "($res)" end
    
    res

end

## -- PART 1 --
rgx_1 = join(["^", solve_rule(rules, 0), "\$"])
solution_1 = sum(.!isnothing.(match.(Regex(rgx_1), targets)))

## -- PART 2 --
## Rule 8 repeats 42 1+ times
## Rule 11 repeats 42 AND 31 1+ (but, an equal #) times
new_rules = copy(rules)
new_rules[8] = [[42], [42, 8]]
new_rules[11] = [[42, 31], [42, 11, 31]]
rgx_2 = join(["^", solve_rule(new_rules, 0), "\$"])

## N8 placeholder can just be replaced with +
rgx_2 = replace(rgx_2, "N8" => "+")

## For N11 we loop since they have to be of equal length
ismatched = [false]
for n11 = 1:10 ## arbitrary, practical limit
    tmp = replace(rgx_2, "N11" => "{$n11}")
    global ismatched = ismatched .| .!isnothing.(match.(Regex(tmp), targets))
end

solution_2 = sum(ismatched)

## -- CHECK -- ##
check_answer(solution_1, 19, 1)
check_answer(solution_2, 19, 2)