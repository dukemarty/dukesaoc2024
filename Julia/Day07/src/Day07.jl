import aoclib as aoc

module Day07

import aoclib as aoc

struct Equation
    TestVal :: Int64
    Numbers :: Vector{Int64}
end

function load_data(file_path)
    lines = aoc.load_multilines(file_path)

    return map(l -> parse_equation(l), lines)
end

function parse_equation(line)
    mp = split(line, ":")
    testVal = parse(Int64, mp[1])

    return Equation(testVal, map(t -> parse(Int64, t), split(mp[2])))
end

function part1(equations)
    aoc.print_part_header(1, "Total Calibration Result #1")

    res = 0
    for eq in equations
        if is_equation_solvable_part1(eq)
            res += eq.TestVal
        end
    end

    println("Result with +/-: $res")
end

function is_equation_solvable_part1(eq)
    todo = [ [eq.Numbers[1], copy(eq.Numbers[2:end])]]
    while length(todo) > 0
        ne = popfirst!(todo)
        # println("ne: $ne")
        nn = popfirst!(ne[2])
        # println("nn: $nn")
        r1 = ne[1] + nn
        r2 = ne[1] * nn
        if isempty(ne[2])
            if r1 == eq.TestVal || r2 == eq.TestVal
                return true
            end
        else
            push!(todo, [r1, copy(ne[2])])
            push!(todo, [r2, copy(ne[2])])
        end
        # println("   $todo")
    end

    return false
end

function part2(equations)
    aoc.print_part_header(2, "Total Calibration Result #2")

    res = 0
    for eq in equations
        if is_equation_solvable_part2(eq)
            res += eq.TestVal
        end
    end

    println("Result with +/-/||: $res")
end

function is_equation_solvable_part2(eq)
    todo = [ [eq.Numbers[1], copy(eq.Numbers[2:end])]]
    while length(todo) > 0
        ne = popfirst!(todo)
        # println("ne: $ne")
        nn = popfirst!(ne[2])
        # println("nn: $nn")
        r1 = ne[1] + nn
        r2 = ne[1] * nn
        r3 = parse(Int64, string(ne[1])string(nn))
        if isempty(ne[2])
            if r1 == eq.TestVal || r2 == eq.TestVal || r3 == eq.TestVal
                return true
            end
        else
            push!(todo, [r1, copy(ne[2])])
            push!(todo, [r2, copy(ne[2])])
            push!(todo, [r3, copy(ne[2])])
        end
        # println("   $todo")
    end

    return false
end


end # module Day07


# equations = Day07.load_data("test.txt")
equations = Day07.load_data("puzzle.txt")
# println(equations)

aoc.print_day_header(7, "Bridge Repair")

Day07.part1(equations)

Day07.part2(equations)
