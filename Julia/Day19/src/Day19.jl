import aoclib as aoc

module Day19

import aoclib as aoc
using DataStructures

function load_data(file_path)
    blocks = aoc.io.load_multiline_blocks(file_path)

    towels = map(s -> strip(s), split(blocks[1][1], ","))
    
    return towels, blocks[2]
end

function part1(towels, designs)
    aoc.print_part_header(1, "Count possible designs")

    st = Dict(
        'w' =>  towels[map(s -> s[1]=='w', towels)],
        'u' =>  towels[map(s -> s[1]=='u', towels)],
        'b' =>  towels[map(s -> s[1]=='b', towels)],
        'r' =>  towels[map(s -> s[1]=='r', towels)],
        'g' =>  towels[map(s -> s[1]=='g', towels)]
        )

    res = 0

    fc = length(designs)
    c = 1
    for d in designs
        # println("Checking $c/$fc")
        if can_be_realized_part1(d, st)
            res += 1
        end

        c += 1
    end

    println("#Possible designs: $res")
end

function part2(towels, designs)
    aoc.print_part_header(2, "Count ways to realize designs")

    st = Dict(
        'w' =>  towels[map(s -> s[1]=='w', towels)],
        'u' =>  towels[map(s -> s[1]=='u', towels)],
        'b' =>  towels[map(s -> s[1]=='b', towels)],
        'r' =>  towels[map(s -> s[1]=='r', towels)],
        'g' =>  towels[map(s -> s[1]=='g', towels)]
        )

    res = 0

    fc = length(designs)
    c = 1
    for d in designs
        # println("Checking $c/$fc")
        res += realize_part2(d, st)

        c += 1
    end

    println("Sum of ways to realize designs: $res")
end

function can_be_realized_part1(design, towels)
    cands = PriorityQueue()
    enqueue!(cands, design, length(design))

    seen = Set()

    while length(cands) > 0
        c = dequeue!(cands)
        for t in towels[c[1]]
            if startswith(c, t)
                lc, lt = length(c), length(t)
                if lc == lt
                    return true
                else
                    new_cand = c[lt+1:end]
                    if !(new_cand in seen)
                        push!(seen, new_cand)
                        enqueue!(cands, new_cand, lc - lt)
                    end
                end
            end
        end
    end

    return false
end

function realize_part2(design, towels)
    cands = PriorityQueue()
    enqueue!(cands, design, 0)

    seen = Dict( design => 1 )

    l = length(design)
    while length(cands) > 0
        c = dequeue!(cands)
        for t in towels[c[1]]
            if startswith(c, t)
                lc, lt = length(c), length(t)
                if lc == lt
                    if haskey(seen, "")
                        seen[""] += seen[c]
                    else
                        seen[""] = seen[c]
                    end
                else
                    new_cand = c[lt+1:end]
                    if haskey(seen, new_cand)
                        seen[new_cand] += seen[c]
                    else
                        seen[new_cand] = seen[c]
                        enqueue!(cands, new_cand, l - length(new_cand))
                    end
                end
            end
        end
    end

    if haskey(seen, "")
        return seen[""]
    else
        return 0
    end
end

end # module Day19

aoc.print_day_header(19, "Linen Layout")

# towels, designs = Day19.load_data("test.txt")
towels, designs = Day19.load_data("puzzle.txt")
# println(towels)
# println(designs)

Day19.part1(towels, designs)

Day19.part2(towels, designs)
