module Day01

    function load_puzzle(file_path)
        file_content = read(file_path, String)

        return file_content
    end

# Specify the path to your file file_path = "example.txt" # Open the file and read its content as a string file_content = read(file_path, String) println(file_content) # Output: Hello, Julia!
    greet() = println("Hello, world!")

end

data = Day01.load_puzzle("D:/SYS/loesch/Dropbox/Advent_of_Code-2024.git/Julia/prestudy01_aoc_2015_01/src/puzzle.txt")

# println(data)

myx = 0
pos = 1
reached_once = false
for c in data
    global reached_once
    global myx
    global pos
    myx += 
        if c == '('
            1
        elseif c == ')'
            -1
        else
            0
        end
    
    if (!reached_once && myx == -1)
        println("Reached floor -1 in step ", pos)
        # break
        reached_once = true
    end
    pos += 1
end

println("Ending up on floor: ", myx)
