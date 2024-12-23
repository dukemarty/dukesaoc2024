import aoclib as aoc

module Day23

import aoclib as aoc

function load_data(file_path)

    lines = aoc.io.load_multilines(file_path)
    map(l -> split(l, "-"), lines)


end

function part1(connections)
    aoc.print_part_header(1, "Comuter triples with maybe chief historian")

    res = 0

    conns = Dict()
    for c ∈ connections
        if haskey(conns, c[1])
            push!(conns[c[1]], c[2])
        else
            conns[c[1]] = [c[2]]
        end
        if haskey(conns, c[2])
            push!(conns[c[2]], c[1])
        else
            conns[c[2]] = [c[1]]
        end
    end
    println(conns)
    tk = filter(k -> startswith(k, "t"), keys(conns))
    println(tk)
    for k in tk
        if length(conns[k]) > 3
            println("Skipped because initial length > 3")
            continue
        end
        seen = Set(conns[k])
        push!(seen, k)
        todo = conns[k]
        while length(todo) > 0
            next = pop!(todo)
            for c ∈ conns[next]
                if c ∈ seen
                    continue
                end
                push!(seen, c)
                push!(todo, c)
            end
        end
        if length(seen) == 3
            println("Found another set: $seen")
            res += 1
        else
            println("Final set to large: $seen")
        end
    end

    println("Count of triples with t.* computer: $res")
end

end # module Day23

connections = Day23.load_data("test.txt")
# connections = Day23.load_data("puzzle.txt")
# println(connections)

aoc.print_day_header(23, "LAN Party")

Day23.part1(connections)


