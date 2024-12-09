import aoclib as aoc

module Day08

import aoclib as aoc

function load_data(file_path)
    map = aoc.load_char_array(file_path)
    antennas = Dict{Char,Vector{Vector{Int64}}}()
    ms = size(map)
    for r = 1:ms[1], c = 1:ms[2]
        if map[r, c] != '.'
            if !haskey(antennas, map[r, c])
                antennas[map[r, c]] = []
            end
            push!(antennas[map[r, c]], [r, c])
        end
    end
    return map, antennas
end

function part1(orig, antennas)
    aoc.print_part_header(1, "Unique Antinode Locations Count #1")
    map = copy(orig)
    ms = size(map)

    for (asym, alocs) in antennas
        # println("Antenna: $asym @ $alocs")
        # for i in eachindex(a[1:(end-1)])
        for i in eachindex(alocs[1:(end-1)])
            for j in (i+1):length(alocs)
                # println("Compare antenna $i with $j")
                v = alocs[i] - alocs[j]
                p1 = alocs[i] + v
                p2 = alocs[j] - v
                # println("  v=$v => p1=$p1  p2=$p2")
                if is_inside(ms, p1)
                    # println("  trying to set p1")
                    s_at(p1, map, '#')
                end
                if is_inside(ms, p2)
                    # println("  trying to set p2")
                    s_at(p2, map, '#')
                end
            end
        end
    end

    # println(map)

    res = count(c -> c == '#', map)

    println("#Antinode locations: $res")
end

function part2(orig, antennas)
    aoc.print_part_header(2, "Unique Antinode Locations Count #2")
    map = copy(orig)
    ms = size(map)

    for (asym, alocs) in antennas
        # println("Antenna: $asym @ $alocs")
        # for i in eachindex(a[1:(end-1)])
        for i in eachindex(alocs[1:(end-1)])
            s_at(alocs[i], map, '#')
            for j in (i+1):length(alocs)
                # println("Compare antenna $i with $j")
                v = alocs[i] - alocs[j]
                p1 = alocs[i] + v
                while is_inside(ms, p1)
                    s_at(p1, map, '#')
                    p1 = p1 + v
                end
                p2 = alocs[j] - v
                while is_inside(ms, p2)
                    s_at(p2, map, '#')
                    p2 = p2 - v
                end
            end
        end
        s_at(alocs[end], map, '#')
    end

    # println(map)

    res = count(c -> c == '#', map)

    println("#Antinode locations: $res")
end

is_inside(mapsize, pos) = pos[1] > 0 && pos[2] > 0 && pos[1] <= mapsize[1] && pos[2] <= mapsize[2]

function s_at(pos::Vector{Int64}, map::Matrix{Char}, value::Any)
    map[pos[1], pos[2]] = value
end

end # module Day08

# map, antennas = Day08.load_data("test.txt")
map, antennas = Day08.load_data("puzzle.txt")
# println(map)
# print(antennas)

aoc.print_day_header(8, "Resonant Collinearity")

Day08.part1(map, antennas)

Day08.part2(map, antennas)
