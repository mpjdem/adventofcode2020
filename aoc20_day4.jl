## Advent of Code 2020, Day 4
## https://adventofcode.com/2020/day/4
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input4.txt", "r") do file
    string.(split(join(readlines(file), " "), "  "))
end

pp_strings = Dict.(map(x -> map(y -> String.(y), 
                                split.(x, ":")), 
                       split.(inp, " ")))

## -- PART 1 --
required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
optional_fields = ["cid"]
solution_1 = sum(map(x -> isempty(setdiff(required_fields, keys(x))), pp_strings))

## -- PART 2 --
struct Passport
    byr::Int
    iyr::Int
    eyr::Int
    hgt::String
    hcl::String
    ecl::String
    pid::String
    cid::Any
end

function isbetween(n::Int, min_n::Int, max_n::Int)::Bool
    n >= min_n && n <= max_n
end
    
function Passport(ppd::Dict{String, String})::Passport

    byr = parse(Int, ppd["byr"])
    valid = isbetween(byr, 1920, 2002)

    iyr = parse(Int, ppd["iyr"])
    valid = valid && isbetween(iyr, 2010, 2020)

    eyr = parse(Int, ppd["eyr"])
    valid = valid && isbetween(eyr, 2020, 2030)

    hgt = ppd["hgt"]
    valid = valid && ((occursin(r"^[0-9]{3}cm$", hgt) && isbetween(parse(Int, hgt[1:3]), 150, 193)) || 
                      (occursin(r"^[0-9]{2}in$", hgt) && isbetween(parse(Int, hgt[1:2]), 59, 76)))
    
    hcl = ppd["hcl"]
    valid = valid && occursin(r"^#[0-9a-f]{6}$", hcl)
    
    ecl = ppd["ecl"]
    valid = valid && occursin(r"^amb|blu|brn|gry|grn|hzl|oth$", ecl)

    pid = ppd["pid"]
    valid = valid && occursin(r"^[0-9]{9}$", pid)

    cid::Any = if haskey(ppd, "cid") ppd["cid"] else Nothing end

    if !valid throw(ArgumentError("Some passport fields are invalid")) end

    Passport(byr, iyr, eyr, hgt, hcl, ecl, pid, cid)

end

results = map(pp -> try Passport(pp) catch Nothing end, pp_strings)
solution_2 = sum(isa.(results, Passport))

## -- CHECK -- 
check_answer(solution_1, 4, 1)
check_answer(solution_2, 4, 2)