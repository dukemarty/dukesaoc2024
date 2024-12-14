import aoclib as aoc

module Day12

import aoclib as aoc

function load_data(file_path)
    raw = aoc.load_char_array(file_path)

    sz = size(raw)
    gmap = copy(raw)
    gmap = hcat(repeat(['\0'], sz[1]), gmap, repeat(['\0'], sz[1]))
    gmap = vcat(repeat(['\0'], 1, sz[2] + 2), gmap, repeat(['\0'], 1, sz[2] + 2)) 

    return gmap
end

# up, right, down, left = [-1, 0], [0, 1], [1, 0], [0, -1]
dirs = [[-1, 0], [0, 1], [1, 0], [0, -1]]

function part1(garden)
    aoc.print_part_header(1, "")

    gsize = size(garden)
    seen = repeat([false], gsize[1] - 2, gsize[2] - 2)
    seen = hcat(repeat([true], gsize[2] - 2), seen, repeat([true], gsize[2] - 2))
    seen = vcat(repeat([true], 1, gsize[2]), seen, repeat([true], 1, gsize[2]))
    # println(seen)
    cost = 0

    for r ∈ 1:gsize[1], c ∈ 1:gsize[2]
        if seen[r, c] continue end
        sym = garden[r, c]
        # println("Processing '$sym' from pos ($r, $c)")
        area, perimeter = 0, 0
        plots = Set()
        push!(plots, [r, c])
        while length(plots) > 0
            next = pop!(plots)
            # println("  Working in pos $next")
            s_at(next, seen, true)
            area += 1
            for d ∈ dirs
                neighbor = next + d
                if g_at(neighbor, garden) != sym
                    perimeter += 1
                    # println("    increased perimeter with dir $d")
                elseif !g_at(neighbor, seen)
                    push!(plots, neighbor)
                    # println("    added plot $neighbor")
                end
            end
        end
        cost += area * perimeter
        # println("  a*p=c: $area * $perimeter = $cost")
    end

    println("Fence cost: $cost")
end

g_at(pos::Vector{Int64}, map) = map[pos[1], pos[2]]

s_at(pos::Vector{Int64}, map, value) = map[pos[1], pos[2]] = value

end # module Day12

# garden = Day12.load_data("test1.txt")
# garden = Day12.load_data("test2.txt")
garden = Day12.load_data("puzzle.txt")
# println(garden)

aoc.print_day_header(12, "Garden Groups")

Day12.part1(garden)

# Day12.part2(garden)
