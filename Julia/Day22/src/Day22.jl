import aoclib as aoc

module Day22

import aoclib as aoc

function load_data(file_path)
    raw = aoc.io.load_multilines(file_path)

    map(n -> parse(Int64, n), raw)
end

function part1(seeds)
    aoc.print_part_header(1, "Sum of 2000th numbers")

    res = 0
    for s in seeds
        l = produce_n(s, 2000)
        res += l[end]
    end

    println("Sum: $res")
end

function part2(seeds)
    aoc.print_part_header(2, "Optimal bargain")

    lists = [map(n -> n % 10, produce_n(s, 2000)) for s in seeds]
    # println(lists)
    pos_win = Dict()
    for l in lists
        d = Dict()
        dl = [l[2]%10 - l[1], l[3] - l[2], l[4] - l[3], l[5] - l[4]]
        d[copy(dl)] = l[5]
        # println(dl)
        for i ∈ 6:length(l)
            popfirst!(dl)
            push!(dl, l[i] - l[i-1])
            # println(dl)
            if !haskey(d, dl)
                d[copy(dl)]= l[i]
            end
        end
        # println(d)
        for p in d
            if haskey(pos_win, p[1])
                # println("Seq. $(p[1]) already in, add value $(p[2])")
                pos_win[p[1]] += p[2]
            else
                # println("Add new seq. $(p[1]) for $(p[2])")
                pos_win[copy(p[1])] = p[2]
            end
        end
    end
    # println(pos_win)

    best = argmax(p -> p[2], pos_win)
    println("Best order: $best")

    println("Most bananas: $(best[2])")
end

function produce_n(seed, n)
    res = [seed]

    for _ ∈ 1:n
        push!(res, evolve(res[end]))
    end
    # println("$seed: $(res[2001])")

    res
end

function produce_2000_part1(seed)
    res = [seed]

    for _ ∈ 1:2000
        push!(res, evolve(res[end]))
    end
    # println("$seed: $(res[2001])")

    res
end

function evolve(n)
    n = prune(mix(n, n * 64))
    n = prune(mix(n, n ÷ 32))
    n = prune(mix(n, n * 2048))

    n
end

mix(m, n) = m ⊻ n

prune(n) = n % 16777216

end # module Day22

# initial_secret_numbers = Day22.load_data("test1.txt")
# initial_secret_numbers = Day22.load_data("test2.txt")
# initial_secret_numbers = Day22.load_data("test3.txt")
initial_secret_numbers = Day22.load_data("puzzle.txt")
println(initial_secret_numbers)

aoc.print_day_header(22, "Monkey Market")

Day22.part1(initial_secret_numbers)

Day22.part2(initial_secret_numbers)
