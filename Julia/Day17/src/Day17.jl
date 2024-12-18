import aoclib as aoc

module Day17

include("Computer.jl")

import aoclib as aoc

rgx_register = r"Register (?P<regname>\w): (?P<regvalue>\d+)"
rgx_program = r"Program: (?P<prog>[\d,]+)"

function load_data(file_path)
    blocks = aoc.io.load_multiline_blocks(file_path)

    regs = parse_registers(blocks[1])

    m_prog = match(rgx_program, blocks[2][1])
    prog = map(d -> parse(Int16, d), split(m_prog["prog"], ","))

    regs, prog    
end

function parse_registers(lines)
    res = Dict()

    for l in lines
        m = match(rgx_register, l)
        res[m["regname"]] = parse(Int32, m["regvalue"])
    end

    res
end

function part1(regs, prog)
    aoc.print_part_header(1, "Program output")

    mach = computer.Machine(1, copy(regs), prog, [])
    println(mach)

    computer.run_prog(mach)
    
    output = join(mach.Output, ",")

    println("Output: $output")
end

function part2(orig_regs, prog)
    aoc.print_part_header(2, "Reg A value for self-reproduction")

    mach = computer.Machine(1, copy(orig_regs), prog, [])

    target = join(prog, ",")

    i = -1
    i = 316505789
    i = 338522042
    output = ""
    println("Target program: $prog")
    while output != target
        i += 2
        # println("$i")
        regs = copy(orig_regs)
        regs["A"] = i
        computer.reset(mach, regs)
        res = computer.run_prog_with_target(mach, prog)

        if res > length(prog)
            println("Found match with i = $i")
            break
        elseif res > 5
            println("$res matches ($(mach.Output)) with: $i")
        end

        # output = join(mach.Output, ",")

    end
    
    println("Solution: $i")

end

end # module Day17

# regs, prog = Day17.load_data("test1.txt")
# regs, prog = Day17.load_data("test2.txt")
regs, prog = Day17.load_data("puzzle.txt")
# println("Registers: $regs")
# println("Program: $prog")

aoc.print_day_header(17, "Chronospatial Computer")

Day17.part1(regs, prog)

Day17.part2(regs, prog)
