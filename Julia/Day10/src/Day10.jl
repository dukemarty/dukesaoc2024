import aoclib as aoc

module Day10

import aoclib as aoc

function load_data(file_path)
    raw = aoc.load_char_array(file_path)

    return map(c -> parse(Int8, c), raw)
end

function part1(tmap)
    aoc.print_part_header(1, "Trailheads score sum")

    # surround map with -1 as guards
    ts = size(tmap)
    etmap = copy(tmap)
    etmap = hcat(repeat([-1], ts[1]), etmap, repeat([-1], ts[1]))
    etmap = vcat(repeat([-1], 1, ts[2] + 2), etmap, repeat([-1], 1, ts[2] + 2))
    # println(etmap)

    ets = size(etmap)
    res = 0
    for r = 1:ets[1], c = 1:ets[2]
        if etmap[r, c] == 0
            res += count_trails_part1(etmap, [r, c])
        end
    end

    println("Score's sum: $res")
end

function part2(tmap)
    aoc.print_part_header(2, "Trailheads rating sum")

    # surround map with -1 as guards
    ts = size(tmap)
    etmap = copy(tmap)
    etmap = hcat(repeat([-1], ts[1]), etmap, repeat([-1], ts[1]))
    etmap = vcat(repeat([-1], 1, ts[2] + 2), etmap, repeat([-1], 1, ts[2] + 2))
    # println(etmap)

    ets = size(etmap)
    res = 0
    for r = 1:ets[1], c = 1:ets[2]
        if etmap[r, c] == 0
            res += count_trails_part2(etmap, [r, c])
        end
    end

    println("Rating's sum: $res")
end

struct TrailPos
    Height::Int8
    Pos::Vector{Int64}
end

# up, right, down, left = [-1, 0], [0, 1], [1, 0], [0, -1]
dirs = [[-1, 0], [0, 1], [1, 0], [0, -1]]

function count_trails_part1(map, pos0)
    trail_ends = Set()
    open_trails = [TrailPos(0, pos0)]

    while length(open_trails) > 0
        t = popfirst!(open_trails)
        for d ∈ dirs
            if g_at(t.Pos + d, map) == t.Height + 1
                if t.Height + 1 == 9
                    push!(trail_ends, t.Pos + d)
                else
                    push!(open_trails, TrailPos(t.Height + 1, t.Pos + d))
                end
            end
        end
    end

    return length(trail_ends)
end

function count_trails_part2(map, pos0)
    res = 0
    open_trails = [TrailPos(0, pos0)]

    while length(open_trails) > 0
        t = popfirst!(open_trails)
        for d ∈ dirs
            if g_at(t.Pos + d, map) == t.Height + 1
                if t.Height + 1 == 9
                    res += 1
                else
                    push!(open_trails, TrailPos(t.Height + 1, t.Pos + d))
                end
            end
        end
    end

    return res
end

g_at(pos::Vector{Int64}, map) = map[pos[1], pos[2]]

end # module Day10

# topo_map = Day10.load_data("test.txt")
topo_map = Day10.load_data("puzzle.txt")
# println(topo_map)

aoc.print_day_header(10, "Bridge Repair")

Day10.part1(topo_map)

Day10.part2(topo_map)
