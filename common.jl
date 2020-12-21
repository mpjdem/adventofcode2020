
function check_answer(solution, day_number::Int, part_number::Int)::Nothing
   
    fname = "output/output" * string(day_number) * "_" * string(part_number) * ".txt"

    check =  open(fname) do file
        readline(file)
    end

    evaluation_str = if string(solution) == check "correct!" else "wrong!" end

    println("Solution to Day " * string(day_number) * " Part " * string(part_number) * ": " * string(solution) * " - " * string(evaluation_str))

    return

end