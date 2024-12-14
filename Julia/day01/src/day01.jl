import aoclib as aoc

module Day01

import aoclib as aoc

function load_multilines(file_path)
    file_content = read(file_path, String)
    lines = split(file_content, "\r\n")

    return lines
end

function load_puzzle(file_path)
    lines = load_multilines(file_path)
    tokens = map(l -> split(l, " "), lines)
    return map(t -> parse(Int32, t[1]), tokens), map(t -> parse(Int32, t[4]), tokens)
end

function part1(l, r)
    aoc.print_part_header(1, "Total List Distance")
    ls = sort(l)
    rs = sort(r)

    tld = 0
    for i = eachindex(ls)
        tld += abs(rs[i] - ls[i])
    end

    println("Total dist: $tld")

end

function part2(l, r)
    aoc.print_part_header(2, "Similarity Score")

    d = Dict(le => count(re -> le==re, r) for le in Set(l))
    # println(d)

    score = 0
    for le in l
        score += le * get!(d, le, 0)
    end

    println("Similarity score: $score")
end

greet() = print("Hello World!")

end # module day01


# data_left, data_right = Day01.load_puzzle("test.txt")
data_left, data_right = Day01.load_puzzle("puzzle.txt")


aoc.print_day_header(1, "Historian Hysteria")

Day01.part1(data_left, data_right)

Day01.part2(data_left, data_right)

