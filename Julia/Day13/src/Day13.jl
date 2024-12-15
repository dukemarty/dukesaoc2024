import aoclib as aoc

module Day13

import aoclib as aoc

#Button A: X+94, Y+34
#Button B: X+22, Y+67
rgx_button = r"Button \w: X\+(\d+), Y\+(\d+)"
#Prize: X=8400, Y=5400
rgx_prize = r"Prize: X=(\d+), Y=(\d+)"

struct Machine
    ButtonA :: Vector{Int32}
    ButtonB :: Vector{Int32}
    Prize :: Vector{Int32}
end

function load_data(file_path)
    raw = aoc.load_multiline_blocks(file_path)
    machines = map(b -> parse_machine(b), raw)
    
    return machines
end

function parse_machine(block)
    mb1 = match(rgx_button, block[1], 1)
    mb2 = match(rgx_button, block[2], 1)
    mp = match(rgx_prize, block[3], 1)

    return Machine([parse(Int64, mb1.captures[1]), parse(Int64, mb1.captures[2])], [parse(Int64, mb2.captures[1]), parse(Int64, mb2.captures[2])], [parse(Int64, mp.captures[1]), parse(Int64, mp.captures[2])])
end

# cost button a, cost button b
button_costs = [3, 1]

function part1(machines)
    aoc.print_part_header(1, "Fewest tokens to win all")

    res = 0
    for m in machines
        sol = try_solve_part1(m)
        println("Solution: $sol")
        if isnothing(sol)
            continue
        end
        res += sum(sol.*button_costs)
    end

    println("Cost for maximum wins: $res")
end

function try_solve_part1(machine)
    max_b = min(minimum(machine.Prize .÷ machine.ButtonB), 100)
    for i ∈ max_b:-1:0
        rem = machine.Prize - machine.ButtonB*max_b
        # println("Remainder: $rem")
        div_x, rem_x = rem[1] ÷ machine.ButtonA[1], rem[1] % machine.ButtonA[1]
        # println("  div_x=$div_x, rem_x=$rem_x")
        if rem_x == 0
            if div_x*machine.ButtonA[2] == rem[2]
                return [div_x, max_b]
            end
        end
        max_b -= 1
    end

    return nothing
end

function part2(machines)
    aoc.print_part_header(2, "Fewest tokens after correction")

    res = 0
    for m in machines
        sol = try_solve_part2(m)
        println("Solution: $sol")
        if isnothing(sol)
            continue
        end
        res += sum(sol.*button_costs)
    end

    println("Corrected cost for maximum wins: $res")
end

function try_solve_part2(machine)
    correction = [10000000000000, 10000000000000]
    prize = machine.Prize + correction
    max_b = minimum(prize .÷ machine.ButtonB)
    for i ∈ max_b:-1:0
        rem = prize - machine.ButtonB*max_b
        # println("Remainder: $rem")
        div_x, rem_x = rem[1] ÷ machine.ButtonA[1], rem[1] % machine.ButtonA[1]
        # println("  div_x=$div_x, rem_x=$rem_x")
        if rem_x == 0
            if div_x*machine.ButtonA[2] == rem[2]
                return [div_x, max_b]
            end
        end
        max_b -= 1
    end

    return nothing
end

end # module Day13


machines = Day13.load_data("test.txt")
# machines = Day13.load_data("puzzle.txt")
# println(machines)

aoc.print_day_header(13, "Claw Contraption")

Day13.part1(machines)

Day13.part2(machines)
