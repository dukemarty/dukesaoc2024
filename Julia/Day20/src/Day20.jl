import aoclib as aoc

module Day20

import aoclib as aoc
import aoclib.matrix as mx

function load_data(file_path)
    maze = aoc.io.load_char_array(file_path)
    spos, epos = mx.find(maze, 'S'), mx.find(maze, 'E')

    maze, spos, epos
end

function part1(maze, spos, epos)
    aoc.print_part_header(1, "Count of ≥ 100 saves for max 2 cheat")

    stepmap, steps = determine_steps_part1(maze, spos, epos)
    # display(stepmap)
    # println(steps)

    ms = size(maze)
    saves_100 = 0
    for s in steps
        s_val = mx.g_at(s, stepmap)
        for v in values(mx.sym2dir)
            np = s + 2 * v
            if !mx.is_inside(ms, np)
                continue
            end
            n_val = mx.g_at(np, stepmap)

            if n_val > s_val + 2
                save = n_val - s_val - 2
                # println("Found cheat for $save")
                if save >= 100
                    saves_100 += 1
                end
            end
        end
    end

    println("#Saves: $saves_100")
end

function part2(maze, spos, epos)
    aoc.print_part_header(2, "Count of ≥ 100 saves for max 20 cheat")

    steps = determine_steps_part2(maze, spos, epos)
    # println(steps)

    # hist = fill(0, 84)

    saves_100 = 0
    for si in eachindex(steps)
        for sni in (si+2):length(steps)
            dist = mx.manhattan_dist(steps[si], steps[sni])
            if dist > 20
                continue
            end
            save = sni - si - dist
            if save >= 100
                # hist[save] += 1
                saves_100 += 1
            end
        end

    end
    # for hi in eachindex(hist)
    #     if hist[hi] > 0
    #         println("There are $(hist[hi]) cheats for $hi picoseconds.")
    #     end
    # end
    
    println("#Saves: $saves_100")
end

function determine_steps_part1(maze, spos, epos)
    ms = size(maze)
    stepmap = fill(-1, ms[1], ms[2])
    steps = []
    # display(stepmap)

    ppos = copy(spos)
    pos = copy(spos)
    s = 0
    mx.s_at(pos, stepmap, s)
    while pos != epos
        push!(steps, pos)
        s += 1
        for d in values(mx.sym2dir)
            npos = pos + d
            if npos == ppos
                continue
            end
            if mx.g_at(npos, maze) == '#'
                continue
            end
            ppos = pos
            pos = npos
            break
        end
        mx.s_at(pos, stepmap, s)
    end
    # display(stepmap)

    stepmap, steps
end

function determine_steps_part2(maze, spos, epos)
    steps = []

    ppos = copy(spos)
    pos = copy(spos)
    s = 0
    while pos != epos
        push!(steps, pos)
        s += 1
        for d in values(mx.sym2dir)
            npos = pos + d
            if npos == ppos
                continue
            end
            if mx.g_at(npos, maze) == '#'
                continue
            end
            ppos = pos
            pos = npos
            break
        end
    end
    push!(steps, pos)

    steps
end

end # module Day20

# maze, startpos, endpos = Day20.load_data("test.txt")
maze, startpos, endpos = Day20.load_data("puzzle.txt")
# println("Maze:")
# display(maze)
# println("Start & end pos: $startpos -> $endpos")

aoc.print_day_header(20, "Race Condition")

# Day20.part1(maze, startpos, endpos)

Day20.part2(maze, startpos, endpos)
