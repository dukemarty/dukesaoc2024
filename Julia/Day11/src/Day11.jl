import aoclib as aoc

module Day11

import aoclib as aoc

function load_data(data)
    tokens = split(data)
    return map(n -> parse(Int64, n), tokens)
end

function part1(pebbles)
    aoc.print_part_header(1, "Pebble count after #25")

    for i ∈ 1:25
        expansion = []
        for p in pebbles
            s = string(p)
            if p == 0
                push!(expansion, 1)
            elseif length(s) % 2 == 0
                middle = length(s) ÷ 2
                p1, p2 = s[1:middle], s[middle+1:end]
                push!(expansion, parse(Int32, p1))
                push!(expansion, parse(Int32, p2))
            else
                push!(expansion, p * 2024)
            end
        end

        pebbles = expansion
    end

    res = length(pebbles)
    println("#Pebbles: $res")
end

function part2(pebbles)
    aoc.print_part_header(2, "Pebble count after #75")

    seen = Set()
    expansions = Dict()
    todo = []
    for p in pebbles
        if !(p in seen)
            push!(todo, p)
            push!(seen, p)
        end
    end
    while length(todo) > 0
        p = popfirst!(todo)
        exp = expand_pebble_part2(p)
        expansions[p] = exp
        for e in exp
            if !(e in seen)
                push!(todo, e)
                push!(seen, e)
            end
        end
    end
    println("Number of different pebbles: $(length(expansions))")

    d = Dict()
    for p in pebbles
        if haskey(d, p)
            d[p] += 1
        else
            d[p] = 1
        end
    end
    for i ∈ 1:75
        d = blink_part2(d, expansions)
        # println("Step $i:\n$d")
    end
    res = sum(values(d))

    println("Number of pebbles after 75 blinks: $res")
end

function expand_pebble_part2(p)
    # println("Called expand for $p")
    s = string(p)
    if p == 0
        return [1]
    elseif length(s) % 2 == 0
        middle = length(s) ÷ 2
        p1, p2 = s[1:middle], s[middle+1:end]
        return [parse(Int32, p1), parse(Int32, p2)]
    else
        return p * 2024
    end
end

function blink_part2(pebble_set, pebble_expansions)
    res = Dict()

    for k in keys(pebble_set)
        for e in pebble_expansions[k]
            if haskey(res, e)
               res[e] += pebble_set[k] 
            else
                res[e] = pebble_set[k] 
            end
        end
    end

    res
end

end # module Day11


data_test = "125 17"
data_puzzle = "1 24596 0 740994 60 803 8918 9405859"


# pebbles = Day11.load_data(data_test)
pebbles = Day11.load_data(data_puzzle)
println(pebbles)

aoc.print_day_header(11, "Plutonian Pebbles")

Day11.part1(pebbles)

Day11.part2(pebbles)
