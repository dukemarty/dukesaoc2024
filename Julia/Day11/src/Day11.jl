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

end # module Day11


data_test = "125 17"
data_puzzle = "1 24596 0 740994 60 803 8918 9405859"


# pebbles = Day11.load_data(data_test)
pebbles = Day11.load_data(data_puzzle)
println(pebbles)

aoc.print_day_header(11, "Plutonian Pebbles")

Day11.part1(pebbles)

# Day06.part2(pebbles)
