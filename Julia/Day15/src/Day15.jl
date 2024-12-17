import aoclib as aoc

module Day15

import aoclib as aoc

function load_data(file_path)
    blocks = aoc.load_multiline_blocks(file_path)

    wmap = aoc.convert_stringarray_to_matrix(blocks[1])

    return wmap, blocks[2]
end

dirs = Dict('^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1])

function part1(original_map, movements)
    aoc.print_part_header(1, "")

    wmap = copy(original_map)
    pos = find_robot(wmap)
    # println("Found robot at $pos")
    aoc.s_at(pos, wmap, '.')

    for m in join(movements)
        next = pos + dirs[m]
        # println(next)
        if aoc.g_at(next, wmap) == '.'
            pos = next
            continue
        elseif aoc.g_at(next, wmap) == '#'
            continue
        elseif aoc.g_at(next, wmap) == 'O'
            if try_push_box_part1(next, dirs[m], wmap)
                pos = next
            end
            continue
        else
            println("BIG ERROR - Unknown symbol in map!")
        end
    end
    
    # println(wmap)

    ws = size(wmap)
    res = 0
    for r = 1:ws[1], c = 1:ws[2]
        if aoc.g_at([r, c], wmap) == 'O'
            res += 100*(r - 1) + (c - 1)
        end
    end

    println("Box coordinates' sum: $res")
end

function part2(original_map, movements)
    aoc.print_part_header(2, "")

    wmap = expand_map_part2(original_map)
    pos = find_robot(wmap)
    # println("Found robot at $pos")
    aoc.s_at(pos, wmap, '.')

    for m in join(movements)
        next = pos + dirs[m]
        # println(next)
        if aoc.g_at(next, wmap) == '.'
            pos = next
            continue
        elseif aoc.g_at(next, wmap) == '#'
            continue
        elseif aoc.g_at(next, wmap) == 'O'
            if try_push_box_part1(next, dirs[m], wmap)
                pos = next
            end
            continue
        else
            println("BIG ERROR - Unknown symbol in map!")
        end
    end
    
    # println(wmap)

    ws = size(wmap)
    res = 0
    for r = 1:ws[1], c = 1:ws[2]
        if aoc.g_at([r, c], wmap) == '['
            res += 100*(r - 1) + (c - 1)
        end
    end

    println("Box coordinates' sum: $res")
end

function expand_map_part2(wmap)

end

function find_robot(wmap)
    ws = size(wmap)
    for r = 1:ws[1], c = 1:ws[2]
        if aoc.g_at([r, c], wmap) == '@'
            return [r, c]
        end
    end
end

function try_push_box_part1(pos, dir, wmap)
    slot = copy(pos)
    while aoc.g_at(slot, wmap) == 'O'
        slot += dir
    end
    if aoc.g_at(slot, wmap) == '#'
        return false
    end

    # else
    aoc.s_at(slot, wmap, 'O')
    aoc.s_at(pos, wmap, '.')

    return true
end

end # module Day15

# wmap, movements = Day15.load_data("test1.txt")
wmap, movements = Day15.load_data("test2.txt")
# wmap, movements = Day15.load_data("puzzle.txt")
# println(wmap)
# println("--------------------------------------------")
# println(movements)

aoc.print_day_header(15, "Warehouse Woes")

Day15.part1(wmap, movements)

Day15.part2(wmap, movements)
