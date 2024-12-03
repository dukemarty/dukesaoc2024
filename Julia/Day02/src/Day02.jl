import aoclib as aoc


module Day02

import aoclib as aoc

function load_data(file_path)
    lines = aoc.load_multilines(file_path)

    tokens = map(l -> split(l, " "), lines)
    return map(ts -> map(t -> parse(Int32, t), ts), tokens)
end

function part1_var1(reports)
    aoc.print_part_header(1, "Detect save reports")

    save_count = 0

    for rep in reports
        l, r = copy(rep), copy(rep)
        push!(l, last(r))
        pushfirst!(r, first(l))
        diff = l - r
        pop!(diff)
        popfirst!(diff)
        if !all(n -> 0 < abs(n) < 4, diff)
            continue
        end
        signs = map(n -> sign(n), diff)
        if all(n -> n == 1, signs) || all(n -> n == -1, signs)
            save_count += 1
        end
        # println("Diff: $diff")
        # println("Signums: $signs")
    end

    println("Number of save reports: $save_count")
end

function part1_var2(reports)
    aoc.print_part_header(1, "Detect save reports")

    save_count = 0

    for rep in reports
        save_count += check_report(rep) ? 1 : 0
    end

    println("Number of save reports: $save_count")
end

function part2(reports)
    aoc.print_part_header(1, "Detect save reports with dampener")

    save_count = 0

    for rep in reports
        if check_report(rep)
            save_count += 1
            continue
        end

        for i = eachindex(rep)
            r = copy(rep)
            deleteat!(r, i)
            if check_report(r)
                save_count += 1
                break
            end
        end
    end

    println("Number of save reports: $save_count")
end

function check_report(rep)
    l, r = copy(rep), copy(rep)
    push!(l, last(r))
    pushfirst!(r, first(l))
    diff = l - r
    pop!(diff)
    popfirst!(diff)
    if !all(n -> 0 < abs(n) < 4, diff)
        return false
    end
    signs = map(n -> sign(n), diff)
    return all(n -> n == 1, signs) || all(n -> n == -1, signs)
end

end # module Day02

# reports = Day02.load_data("test.txt")
reports = Day02.load_data("puzzle.txt")
# println(reports)

aoc.print_day_header(2, "Red-Nosed Reports")

# Day02.part1_var1(reports)
Day02.part1_var2(reports)

Day02.part2(reports)