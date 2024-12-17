import aoclib as aoc

module Day16

import aoclib as aoc
import aoclib.matrix as mx
using DataStructures

function load_data(file_path)
    maze = aoc.io.load_char_array(file_path)
    spos, epos = mx.find(maze, 'S'), mx.find(maze, 'E')

    maze, spos, epos
end

struct Node
    Pos :: Vector{Int64}
    Dir :: Vector{Int64}
    Cost :: Int32
    Estim :: Int32
end

struct Location
    WasVisited :: Bool
    From :: Vector{Int64}
    Cost :: Int32
end

function part1(maze, spos, epos)
    aoc.print_part_header(1, "Shortest path")

    ms = size(maze)
    chart = fill(Location(false, [], 0), ms[1], ms[2])

    pq = PriorityQueue()
    enqueue!(pq, Node(spos, mx.sym2dir['>'], 0, mx.manhattan_dist(spos, epos)*1000), mx.manhattan_dist(spos, epos)*1000)
    # println("spos: $spos")
    # println("Chart: $chart")
    mx.s_at(spos, chart, Location(true, spos, 0))

    while length(pq) > 0
        # println(pq)
        node = dequeue!(pq)
        straight = node.Pos + node.Dir
        leftDir = mx.rotMathLeft * node.Dir
        rightDir = mx.rotMathRight * node.Dir
        for p in [(straight, node.Dir, 1), (node.Pos+leftDir, leftDir, 1001), (node.Pos+rightDir, rightDir, 1001)]
            s = mx.g_at(p[1], maze)
            if s == 'E'
                e = mx.g_at(p[1], chart)
                if !e.WasVisited || (node.Cost + p[3] < e.Cost)
                    mx.s_at(p[1], chart, Location(true, node.Pos, node.Cost + p[3]))
                else
                    if node.Cost + p[3] < e.Cost
                        mx.s_at(p[1], chart, Location(true, node.Pos, node.Cost + p[3]))
                    end
                end
            elseif s == '#'
                # println("Reached wall at $(p[1])")
                continue
            else
                e = mx.g_at(p[1], chart)
                if !e.WasVisited
                    mx.s_at(p[1], chart, Location(true, node.Pos, node.Cost + p[3]))
                    enqueue!(pq, Node(p[1], p[2], node.Cost + p[3], mx.manhattan_dist(p[1], epos)*1000), node.Cost + p[3] + mx.manhattan_dist(p[1], epos)*1000)
                else
                    if node.Cost + p[3] < e.Cost 
                        mx.s_at(p[1], chart, Location(true, node.Pos, node.Cost + p[3]))
                        enqueue!(pq, Node(p[1], p[2], node.Cost + p[3], mx.manhattan_dist(p[1], epos)*1000), node.Cost + p[3] + mx.manhattan_dist(p[1], epos)*1000)
                    end
                end
            end
        end
    end
    
    res = mx.g_at(epos, chart).Cost

    println("Shortest path length: $res")
end


end # module Day16

using DataStructures

# maze, startpos, endpos = Day16.load_data("test1.txt")
# maze, startpos, endpos = Day16.load_data("test2.txt")
maze, startpos, endpos = Day16.load_data("puzzle.txt")
# println("Maze: $maze")
# println("Start pos: $startpos")
# println("End pos: $endpos")

aoc.print_day_header(16, "Reindeer Maze")

Day16.part1(maze, startpos, endpos)

