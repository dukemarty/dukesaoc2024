import aoclib as aoc

module Day23

import aoclib as aoc
using DataStructures

function load_data(file_path)
    lines = aoc.io.load_multilines(file_path)
    map(l -> split(l, "-"), lines)
end

function part1(connections)
    aoc.print_part_header(1, "Computer triples with maybe chief historian")

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
        for i ∈ 1:length(cs)-1, j ∈ i+1:length(cs)
            if cs[j] in conns[cs[i]]
                # println("Found set: $k-$(cs[i])-$(cs[j])")
                push!(found, Set([k, cs[i], cs[j]]))
            end
        end
    end

    res = length(found)

    println("Count of triples with t.* computer: $res")
end

struct Candidate
    members :: Set{String}
    common :: Set{String}
end

function part2(connections)
    aoc.print_part_header(2, "Largest fully interconnected set")

    conns = Dict()
    for c ∈ connections
        if haskey(conns, c[1])
            push!(conns[c[1]], c[2])
        else
            conns[c[1]] = copy(c)
        end
        if haskey(conns, c[2])
            push!(conns[c[2]], c[1])
        else
            conns[c[2]] = copy(c)
        end
    end
    # println(conns)

    tk = filter(k -> startswith(k, "t"), keys(conns))
    # println(tk)

    cands = PriorityQueue(Base.Order.Reverse)
    for k in tk
        cs = conns[k]
        for c ∈ cs
            c == k && continue

            common = intersect(conns[k], conns[c])
            # println("Common: $common")
            enqueue!(cands, Candidate(Set([k, c]), Set(common)), length(common))
        end
    end

    best = Candidate(Set(), Set())
    while length(cands) > 0
        println("  #Cands: $(length(cands))")
        next = dequeue!(cands)
        if length(best.members) > length(next.common)
            break
        end
        for t in setdiff(next.common, next.members)
            common = intersect(next.common, conns[t])
            # println("New common: $(next.common) -> $common")
            members = copy(next.members)
            push!(members, t)
            if length(setdiff(common, members)) == 0
                if length(members) > length(best.members)
                    best = Candidate(members, common)
                    println("New best candidate: $best")
                end
            else
                enqueue!(cands, Candidate(members, Set(common)), length(common))
            end
        end
    end

    println("Best found network: $best")
    res = join(sort(collect(best.members)))

    println("Code of largest network: $res")
end

end # module Day23

# connections = Day23.load_data("test.txt")
connections = Day23.load_data("puzzle.txt")
# println(connections)

aoc.print_day_header(23, "LAN Party")

Day23.part1(connections)

Day23.part2(connections)
