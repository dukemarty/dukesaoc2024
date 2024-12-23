import aoclib as aoc

module Day23

import aoclib as aoc

function load_data(file_path)

    lines = aoc.io.load_multilines(file_path)
    map(l -> split(l, "-"), lines)


end

function part1(connections)
    aoc.print_part_header(1, "Comuter triples with maybe chief historian")

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
    # println(conns)
    tk = filter(k -> startswith(k, "t"), keys(conns))
    # println(tk)
    found = Set()
    for k in tk
        cs = conns[k]
        for i ∈ 1:length(cs)-1
            for j ∈ i+1:length(cs)
                if cs[j] in conns[cs[i]]
                    # println("Found set: $k-$(cs[i])-$(cs[j])")
                    push!(found, Set([k, cs[i], cs[j]]))
                end
            end
        end
    end

    res = length(found)

    println("Count of triples with t.* computer: $res")
end

end # module Day23

# connections = Day23.load_data("test.txt")
connections = Day23.load_data("puzzle.txt")
# println(connections)

aoc.print_day_header(23, "LAN Party")

Day23.part1(connections)


