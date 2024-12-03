import aoclib as aoc

module Day03

import aoclib as aoc

rgx1 = r"mul\((\d\d?\d?),(\d\d?\d?)\)"
rgx2 = r"mul\((\d\d?\d?),(\d\d?\d?)\)|(do\(\))|(don't\(\))"

function part1(program)
    aoc.print_part_header(1, "Add valid multiplications")

    res = 0
    pos = 1
    while true
        found = findnext(rgx1, program, pos)
        if isnothing(found)
            break
        end
        res += exec_mul(match(rgx1, program, found.start))
        pos = found.stop + 1
    end

    println("Sum of multiplications: $res")
end

function part2(program)
    aoc.print_part_header(2, "Add only enabled multiplications")

    res = 0
    pos = 1
    enabled = true
    while true
        found = findnext(rgx2, program, pos)
        if isnothing(found)
            break
        end
        m = match(rgx2, program, found.start)
        if !isnothing(m.captures[3])
            enabled = true
        elseif !isnothing(m.captures[4])
            enabled = false
        elseif enabled
            res += exec_mul(m)
        end
        pos = found.stop + 1
    end

    println("Sum of enabled multiplications: $res")
end

function exec_mul(mulmatch)

    l, r = parse(UInt32, mulmatch.captures[1]), parse(UInt32, mulmatch.captures[2])

    return l * r
end # module Day03

end

# program = aoc.load_singleline("test1.txt")
# program = aoc.load_singleline("test2.txt")
program = aoc.load_singleline("puzzle.txt")
# println(program)

aoc.print_day_header(3, "Mull It Over")

Day03.part1(program)

Day03.part2(program)
