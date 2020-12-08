## Advent of Code 2020, Day 8
## https://adventofcode.com/2020/day/8
##
## Author: Maarten Demeyer <mpjdem@gmail.com>
## GitHub: https://github.com/mpjdem
## Website: https://www.mpjdem.xyz

include("common.jl")

## Game console internals
struct Instruction
    operation::String
    argument::Int
end

mutable struct GameConsole
    instructions::Array{Instruction}
    pointer::Int
    state::Int
    finished::Bool
    function GameConsole(instructions::Array{Instruction})
        new(instructions, 1, 0, false)
    end
end

function step!(gc::GameConsole)
    
    if gc.finished return end
    
    instr = gc.instructions[gc.pointer]
    if instr.operation == "acc"
        gc.state += instr.argument
        gc.pointer += 1
    elseif instr.operation == "jmp"
        gc.pointer += instr.argument
    elseif instr.operation == "nop"
        gc.pointer += 1
    end

    if gc.pointer > length(gc.instructions) 
        gc.finished = true
    end

end

## Read input
inp = open("input/input8.txt", "r") do file
    map(x -> begin
            op, arg = split(x, " ")
            Instruction(string(op), parse(Int, arg))
        end,
        readlines(file))
end

## -- PART 1 --
function debug_infinite_loop(instr::Array{Instruction})::GameConsole
    gc = GameConsole(instr)
    ptr_history = [] 
    while !(gc.pointer in ptr_history)
        push!(ptr_history, gc.pointer)
        step!(gc)
    end
    gc
end

solution_1 = debug_infinite_loop(inp).state

## -- PART 2 --
solution_2 = Nothing
for i in collect(1:length(inp))
    if inp[i].operation == "acc" continue end

    patched = copy(inp)
    if patched[i].operation == "jmp" 
        patched[i] = Instruction("nop", patched[i].argument)
    else 
        patched[i] = Instruction("jmp", patched[i].argument)
    end

    res = debug_infinite_loop(patched)

    if res.finished
        global solution_2 = res.state 
        break 
    end
end

## -- CHECK --
check_answer(solution_1, 8, 1)
check_answer(solution_2, 8, 2)