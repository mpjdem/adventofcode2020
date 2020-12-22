## Advent of Code 2020, Day 22 
## https://adventofcode.com/2020/day/22
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

inp = open("input/input22.txt", "r") do file
    readlines(file)
end

idx2 = only(findall(inp .== "Player 2:"))
deck1 = parse.(Int, inp[2:(idx2 - 2)])
deck2 = parse.(Int, inp[(idx2+1):end])

## -- PART 1 --
while !isempty(deck1) && !isempty(deck2)
    card1 = popat!(deck1, 1)
    card2 = popat!(deck2, 1)
    if card1 > card2 
        push!(deck1, card1)
        push!(deck1, card2)
    else
        push!(deck2, card2)
        push!(deck2, card1)
    end
end

winning_deck = length(deck1) != 0 ? deck1 : deck2
solution_1 = sum(winning_deck .* (length(winning_deck):-1:1))

## -- PART 2 --
function recursive_combat(deck1, deck2)

    local gamestates = [] 

    p1_won_game = undef
    while true 
        
        ## Stop if the same deck composition is encountered again
        this_state = hash([deck1, deck2])
        if this_state in gamestates 
            p1_won_game = true
            break
        else
            push!(gamestates, this_state)
        end

        ## Draw top cards as normal
        card1 = popat!(deck1, 1)
        card2 = popat!(deck2, 1)

        ## Either decide the round by a subgame, or as normal
        p1_won_round = if length(deck1) >= card1 && length(deck2) >= card2
            recursive_combat(deck1[1:card1], deck2[1:card2])[1] == 1
        else
            card1 > card2
        end
        
        ## The winner gets both cards
        if p1_won_round 
            push!(deck1, card1)
            push!(deck1, card2)
        else
            push!(deck2, card2)
            push!(deck2, card1)
        end

        ## If one deck is empty, Stop
        if isempty(deck1) || isempty(deck2)
            p1_won_game = !isempty(deck1)
            break 
        end
        
    end

    winning_deck = p1_won_game ? deck1 : deck2 
    score = sum(winning_deck .* (length(winning_deck):-1:1))
   
    ## Return the winning player and their score
    [p1_won_game ? 1 : 2, score]

end

deck1 = parse.(Int, inp[2:(idx2 - 2)])
deck2 = parse.(Int, inp[(idx2+1):end])
solution_2 = recursive_combat(deck1, deck2)[2]

## -- CHECK --
check_answer(solution_1, 22, 1)
check_answer(solution_2, 22, 2)