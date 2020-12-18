## Advent of Code 2020, Day 18
## https://adventofcode.com/2020/day/18
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input18.txt", "r") do file
    filter.(x -> !isspace(x), readlines(file))
end

function parsexp(xp::String, precedence::String)::Int

    if length(xp) == 1 return(parse(Int, xp)) end

    ## Detect inside how many parentheses each character is
    matchpars = str -> cumsum([x == '(' for x in str]) .- cumsum([x == ')' for x in str])
    pardiff = matchpars(xp)

    ## Remove fully enclosing parentheses
    if sum(pardiff .== 0) == 1 
        xp = xp[2:(end-1)]
        pardiff = matchpars(xp)
    end

    ## We have to work right to left, so find last non-priority operator
    addbidx = [x == '+' for x in xp]; mulbidx = [x == '*' for x in xp]
    if precedence == "add" && sum(mulbidx .& (pardiff .== 0)) != 0
        lastopidx = last(findall((pardiff .== 0) .& mulbidx))
    else
        lastopidx = last(findall((pardiff .== 0) .& (addbidx .| mulbidx)))
    end

    ## Do the op, parsing LHS and RHS recursively (so this op has lowest priority)
    lhs = parsexp(xp[1:(lastopidx - 1)], precedence)
    rhs = parsexp(xp[(lastopidx + 1):end], precedence)
    if xp[lastopidx] == '*' lhs * rhs else lhs + rhs end

end

solution_1 = sum(parsexp.(inp, "none"))
solution_2 = sum(parsexp.(inp, "add"))

## -- CHECK -- ##
check_answer(solution_1, 18, 1)
check_answer(solution_2, 18, 2)