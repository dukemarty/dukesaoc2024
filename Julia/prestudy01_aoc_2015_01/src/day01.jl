module Day01

function print_day_header(day, title)
    println("")
    line = "-- Day $day: $title ---"
    println(line)
    println("="^length(line))
    println("")
end

function print_part_header(id, title)
    println("")
    line = "Part $id: $title"
    println(line)
    println("-"^length(line))
end


function load_puzzle(file_path)
    file_content = read(file_path, String)

    return file_content
end

function part1(data)
    print_part_header(1, "Finally reached floor")
    final_floor = 0
    for c in data
        final_floor +=
            if c == '('
                1
            elseif c == ')'
                -1
            else
                0
            end
    end

    println("Ending up on floor: ", final_floor)
end

function part2(data)
    print_part_header(2, "First time basement")

    current = 0
    pos = 1
    for c in data
        current +=
            if c == '('
                1
            elseif c == ')'
                -1
            else
                0
            end

        if (current == -1)
            println("Reached floor -1 in step: ", pos)
            break
        end

        pos += 1
    end
end

# Specify the path to your file file_path = "example.txt" # Open the file and read its content as a string file_content = read(file_path, String) println(file_content) # Output: Hello, Julia!
greet() = println("Hello, world!")

end

data = Day01.load_puzzle("D:/SYS/loesch/Dropbox/Advent_of_Code-2024.git/Julia/prestudy01_aoc_2015_01/src/puzzle.txt")

Day01.print_day_header(1, "Not Quite Lisp")

Day01.part1(data)

Day01.part2(data)

