import aoclib as aoc

module Day04

import aoclib as aoc

# steps = [ [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1] ]
steps = [ [1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1] ]
text = "MAS"

function load_data(file_path)
    lines = aoc.load_multilines(file_path)

    return lines
end

function part1(wg)
    aoc.print_part_header(1, "Count XMAS occurrences")

    count = 0
    for r = eachindex(wg)
        for c = eachindex(wg[r])
            # println("Check for X at $r/$c :  $(wg[r][c])")
            if wg[r][c] != 'X'
                continue
            end

            for s in steps
                if is_in_grid(wg, [r, c]+3*s)
                    count += check(wg, [r, c], s)
                end
            end
            
        end
    end

    println("Count of XMAS's: $count")
end

function is_in_grid(grid, pos)
    if pos[1] < 1 || pos[2] < 1
        return false
    end

    if pos[1] > length(grid) || pos[2] > length(grid[1])
        return false
    end

    return true
end

function check(grid, pos, step)
    for i = eachindex(text)
        next = pos + i*step
        # println("Check pos: $next -> $(grid[next[1]][next[2]])")
        if grid[next[1]][next[2]] != text[i]
            return 0
        end
    end

    return 1
end

end # module Day04

aoc.print_day_header(4, "Ceres Search")

# word_grid = Day04.load_data("test.txt")
word_grid = Day04.load_data("puzzle.txt")
# println(word_grid)

Day04.part1(word_grid)
