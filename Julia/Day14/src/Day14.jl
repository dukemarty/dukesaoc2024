import aoclib as aoc

module Day14

import aoclib as aoc

mutable struct Robot
    Pos::Vector{Int64}
    Vel::Vector{Int64}
end

function load_data(file_path)
    lines = aoc.load_multilines(file_path)

    map(l -> parse_robot(l), lines)
end

rgx = r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)"

function parse_robot(line)
    # p=3,0 v=-1,-2
    m = match(rgx, line)

    Robot([parse(Int64, m.captures[1]), parse(Int64, m.captures[2])], [parse(Int64, m.captures[3]), parse(Int64, m.captures[4])])
end

function part1(robots, height, width)
    aoc.print_part_header(1, "Safety factor")

    endposes = map(r -> step(r, 100, height, width), robots)
    # println(endposes)

    qcount = [0, 0, 0, 0]
    for r ∈ endposes
        q = determine_quadrant(r, height, width)
        if q > 0
            qcount[q] += 1
        end
    end
    # println("Quadrant counts: $qcount")
    res = qcount[1] * qcount[2] * qcount[3] * qcount[4]

    println("Product of robots in quadrants: $res")
end

function part2(robots, height, width)
    aoc.print_part_header(2, "Seconds to christmas tree")


    for i = 1:10000
        grid = fill(' ', height, width)
        gs = size(grid)
            endposes = map(r -> step(r, i, height, width), robots)
            for ep in endposes
                grid[ep[1]+1, ep[2]+1] = '█'
            end
        open("myplot.txt", "a") do file
            write(file, "Step: $i\r\n")
                for c = 1:gs[2]
                    for r = 1:gs[1]
                        write(file, grid[r,c])
                end
                write(file, "\r\n")
            end
            write(file, "\r\n---------------------------------------------------------\r\n\r\n")
        end
    end
    
end

function part2_v1(robots, height, width)
    aoc.print_part_header(2, "Seconds to christmas tree")


    for i = 1:10000
        grid = fill('.', height, width)
        gs = size(grid)
            endposes = map(r -> step(r, i, height, width), robots)
            for ep in endposes
                grid[ep[1]+1, ep[2]+1] = '#'
            end
        open("myplot.txt", "a") do file
            write(file, "Step: $i\r\n")
            for r = 1:gs[1]
                for c = 1:gs[2]
            write(file, grid[r,c])
                end
                write(file, "\r\n")
            end
            write(file, "\r\n---------------------------------------------------------\r\n\r\n")
        end
    end
    
end

function step(robot, count, height, width)
    movedPos = robot.Pos + robot.Vel * count
    newPos = [(movedPos[1] % height + height) % height, (movedPos[2] % width + width) % width]

    return newPos
end

function determine_quadrant(pos, height, width)
    middle1 = height ÷ 2
    middle2 = width ÷ 2
    if pos[1] < middle1 && pos[2] < middle2
        return 1
    elseif pos[1] < middle1 && pos[2] > middle2
        return 2
    elseif pos[1] > middle1 && pos[2] > middle2
        return 3
    elseif pos[1] > middle1 && pos[2] < middle2
        return 4
    else
        return 0
    end
end

end # module Day14

# robots = Day14.load_data("test.txt")
robots = Day14.load_data("puzzle.txt")
# println(robots)

aoc.print_day_header(14, "Restroom Redoubt")

# Day14.part1(robots, 11, 7)
Day14.part1(robots, 101, 103)

Day14.part2(robots, 101, 103)
