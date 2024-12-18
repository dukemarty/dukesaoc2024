import aoclib as aoc

module Day18

import aoclib as aoc
import aoclib.matrix as mx
using DataStructures

function load_data(file_path)
    lines = aoc.io.load_multilines(file_path)
    blocks = map(l -> parse.(Int64, split(l, ",")), lines)

    blocks
end

struct Step
    Pos::Vector{Int64}
    Cost::Int32
    Estim::Int32
end

struct Location
    WasVisited::Bool
    Cost::Int32
end

function part1(blocks, size, bytecount)
    aoc.print_part_header(1, "Minimum steps number")

    inner = fill('.', size[1], size[2])
    insert_blocks(inner, blocks, bytecount)
    bounded = vcat(fill('#', 1, size[2]), inner, fill('#', 1, size[2]))
    bounded = hcat(fill('#', size[1] + 2), bounded, fill('#', size[1] + 2))
    # println(bounded)

    chart = fill(Location(false, 0), size[1] + 2, size[2] + 2)

    pq = PriorityQueue()
    enqueue!(pq, Step([2, 2], 0, 4 * mx.manhattan_dist([2, 2], size + [1, 1])), 4 * mx.manhattan_dist([0, 0], size + [1, 1]))
    mx.s_at([2, 2], chart, Location(true, 0))

    while length(pq) > 0
        next = dequeue!(pq)
        for d in values(mx.sym2dir)
            p = next.Pos + d
            if mx.g_at(p, bounded) == '#'
                continue
            end

            loc = mx.g_at(p, chart)
            if p == size + [2, 2] && loc.Cost > next.Cost + 1
                mx.s_at(p, chart, Location(true, next.Cost + 1))
            elseif !loc.WasVisited || loc.Cost > next.Cost + 1
                mx.s_at(p, chart, Location(true, next.Cost + 1))
                enqueue!(pq, Step(p, next.Cost + 1, 4 * mx.manhattan_dist(p, size + [1, 1])), next.Cost + 1 + 4 * mx.manhattan_dist(p, size + [1, 1]))
            end
        end
    end

    # display(chart)

    target = mx.g_at(size + [1, 1], chart)
    println("Target position: $target")
    println("Minimum number of steps: $(target.Cost)")
end

function part2(blocks, size, bytecount)
    aoc.print_part_header(1, "First prohibiting block")

    inner = fill('.', size[1], size[2])
    insert_blocks(inner, blocks, bytecount)
    bounded = vcat(fill('#', 1, size[2]), inner, fill('#', 1, size[2]))
    bounded = hcat(fill('#', size[1] + 2), bounded, fill('#', size[1] + 2))
    # println(bounded)

    res = 0
    for i in (bytecount+1):length(blocks)
        mx.s_at(blocks[i] + [2, 2], bounded, '#')
  
        chart = fill(Location(false, 0), size[1] + 2, size[2] + 2)

        pq = PriorityQueue()
        enqueue!(pq, Step([2, 2], 0, 4 * mx.manhattan_dist([2, 2], size + [1, 1])), 4 * mx.manhattan_dist([0, 0], size + [1, 1]))
        mx.s_at([2, 2], chart, Location(true, 0))
    
        while length(pq) > 0
            next = dequeue!(pq)
            for d in values(mx.sym2dir)
                p = next.Pos + d
                if mx.g_at(p, bounded) == '#'
                    continue
                end
    
                loc = mx.g_at(p, chart)
                if p == size + [2, 2] && loc.Cost > next.Cost + 1
                    mx.s_at(p, chart, Location(true, next.Cost + 1))
                elseif !loc.WasVisited || loc.Cost > next.Cost + 1
                    mx.s_at(p, chart, Location(true, next.Cost + 1))
                    enqueue!(pq, Step(p, next.Cost + 1, 4 * mx.manhattan_dist(p, size + [1, 1])), next.Cost + 1 + 4 * mx.manhattan_dist(p, size + [1, 1]))
                end
            end
        end

        target = mx.g_at(size + [1, 1], chart)
        println("With block $i: $target")

        if !target.WasVisited
            res = blocks[i]
            break
        end
    end


    println("1st block to prevent exit: $res")
    println("Format for AoC: $(res[1]),$(res[2])")
end

function insert_blocks(memory, blocks, count)
    for i ∈ 1:count
        mx.s_at(blocks[i] + [1, 1], memory, '#')
    end
end

function part1_false(blocks, size)
    aoc.print_part_header(1, "Minimum steps number")

    pq = PriorityQueue()
    enqueue!(pq, Step([0, 0, 0], 0, 4 * mx.manhattan_dist([0, 0, 0], [size[1], size[2], 1024])))

    while length(pq) > 0
        next = dqueue!(pq)
    end

end

end # module Day18

# blocks, size, part1_bytecount = Day18.load_data("test.txt"), [7, 7], 12
blocks, size, part1_bytecount = Day18.load_data("puzzle.txt"), [71, 71], 1024
# println("Fallings blocks: $blocks")

aoc.print_day_header(18, "RAM Run")

Day18.part1(blocks, size, part1_bytecount)

Day18.part2(blocks, size, part1_bytecount)
