import aoclib as aoc

module Day06

import aoclib as aoc

dirsym = Dict([-1, 0] => '^', [1, 0] => 'v', [0, -1] => '<', [0, 1] => '>')
rot = [0 1; -1 0]

function load_data(file_path)
    map = aoc.load_char_array(file_path)
    # println(map)
    # println(size(map))
    ms = size(map)
    pos = [0, 0]
    for r ∈ 1:ms[1], c ∈ 1:ms[2]
        if map[r, c] == '^'
            pos = [r, c]
            map[r, c] = '.'
            # println(size(map))
            break
        end
    end
    return map, pos
end

function part1(init_map, pos, dir)
    aoc.print_part_header(1, "Guard-visited fields")
    map = copy(init_map)
    rot = [0 1; -1 0]

    map[pos[1], pos[2]] = 'X'
    mapsize = size(map)
    while !is_outside(mapsize, pos)
        next_pos = pos + dir
        if is_outside(mapsize, next_pos)
            break
        end
        if map[next_pos[1], next_pos[2]] == '#'
            dir = rot * dir
            continue
        end
        pos = next_pos
        map[pos[1], pos[2]] = 'X'
    end
    # println("-----------------------------------------------")
    # println(map)
    # println("-----------------------------------------------")
    res = count(c -> c == 'X', map)

    println("Number of visited fields: $res")
end

function part2(init_map, pos, dir)
    aoc.print_part_header(2, "")
    init_pos = copy(pos)
    map = copy(init_map)
    rot = [0 1; -1 0]

    map[pos[1], pos[2]] = dirsym[dir]

    # loopcount = 0
    res = 0
    mapsize = size(map)
    while !is_outside(mapsize, pos)
        # loopcount += 1
        # print("  $loopcount ")

        next_pos = pos + dir
        if is_outside(mapsize, next_pos)
            break
        end
        if map[next_pos[1], next_pos[2]] == '#'
            dir = rot * dir
            continue
        end
        if next_pos != init_pos && check_obstacle_leads_to_circle_part2(pos, dir, map, mapsize)
            # debug_map = copy(map)
            # s_at(pos+dir, debug_map, 'O')
            # println("=== Obstacle at $(pos+dir) ===========")
            # println(debug_map)
            # println("--------------------------------------")
            res += 1
        end
        pos = next_pos
        map[pos[1], pos[2]] = map[pos[1], pos[2]] == '.' ? dirsym[dir] : 'X'
    end

    println("")
    println("Number of possible obstruction positions: $res")
end

# function is_outside(mapsize, pos)
#     return pos[1] < 1 || pos[2] < 1 || pos[1] > mapsize[1] || pos[2] > mapsize[2]
# end

is_outside(mapsize, pos) = pos[1] < 1 || pos[2] < 1 || pos[1] > mapsize[1] || pos[2] > mapsize[2]

# assumption: won't get into a loop created completely by the additional obstacle
function check_obstacle_leads_to_circle_part2(pos, dir, map, mapsize)
    cdir = rot * dir
    cpos = copy(pos)
    cmap = copy(map)
    seen = Set()

    push!(seen, vcat(cpos, cdir))
    while !is_outside(mapsize, cpos)
        npos = cpos + cdir
        if (vcat(npos, cdir) ∈ seen)
            return true
        end
        # print(" ($npos) ")
        if is_outside(mapsize, npos)
            return false
        end
        if g_at(npos, cmap) == '#'
            cdir = rot * cdir
            continue
        elseif g_at(npos, cmap) == dirsym[cdir]
            return true
        end
        cpos = npos
        push!(seen, vcat(cpos, cdir))
        s_at(cpos, cmap, g_at(cpos, cmap) == '.' ? dirsym[cdir] : 'X')
    end

    return false
end

g_at( pos :: Vector{Int64}, map :: Matrix{Base.Char}) = map[pos[1], pos[2]]

function s_at( pos :: Vector{Int64}, map :: Matrix{Char}, value :: Any)
    map[pos[1], pos[2]] = value
end

end # module

# map, init_pos = Day06.load_data("test.txt")
map, init_pos = Day06.load_data("puzzle.txt")
# println(map)
init_dir = [-1, 0]
# println(dir)
# println("$init_pos  -  $init_dir")

aoc.print_day_header(6, "Guard Gallivant")

Day06.part1(map, init_pos, init_dir)

# println(map)

Day06.part2(map, init_pos, init_dir)

# println("$init_pos  -  $init_dir")
