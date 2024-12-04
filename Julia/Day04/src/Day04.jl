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
                    count += check_part1(wg, [r, c], s)
                end
            end
            
        end
    end

    println("Count of XMAS's: $count")
end

function part2(wg)
    aoc.print_part_header(2, "Count X-MAS occurrences")

    count = 0
    for r = eachindex(wg)
        if r == 1 || r == length(wg)
            continue
        end
        
        for c = eachindex(wg[r])
            if c == 1 || c == length(wg[1])
                continue
            end

            # println("Check for X at $r/$c :  $(wg[r][c])")
            if wg[r][c] != 'A'
                continue
            end

            count += check_part2(wg, [r, c])            
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

function check_part1(grid, pos, step)
    for i = eachindex(text)
        next = pos + i*step
        # println("Check pos: $next -> $(grid[next[1]][next[2]])")
        if grid[next[1]][next[2]] != text[i]
            return 0
        end
    end

    return 1
end

function check_part2(grid, pos)
    d1 = grid[pos[1]-1][pos[2]-1]grid[pos[1]+1][pos[2]+1]
    d2 = grid[pos[1]+1][pos[2]-1]grid[pos[1]-1][pos[2]+1]
    # println("d1: $d1      d2: $d2")

    if 'M' in d1 && 'S' in d1 && 'M' in d2 && 'S' in d2
        return 1
    end

    return 0
end

end # module Day04

aoc.print_day_header(4, "Ceres Search")

# word_grid = Day04.load_data("test.txt")
word_grid = Day04.load_data("puzzle.txt")
# println(word_grid)

Day04.part1(word_grid)

Day04.part2(word_grid)
