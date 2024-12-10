import aoclib as aoc

module Day09

import aoclib as aoc

mutable struct Pointer
    FileId::Int32
    ListPos::Int32
    Count::Int32
    IsFile :: Bool
end

function load_data(file_path)
    line = aoc.load_singleline(file_path)

    return map(c -> parse(Int16, string(c)), collect(line))
end

function part1(files)
    aoc.print_part_header(1, "New Checksum")

    cs = 0
    filepos = 0
    lp = Pointer(0, 1, 1, true)
    rp = Pointer(length(files) ÷ 2, length(files), 1, true)
    while lp.ListPos <= rp.ListPos
        if lp.IsFile
            cs += lp.FileId * filepos
            # println("L  $(lp.FileId)@$filepos  ->  $cs")
            lp.Count += 1
            if lp.Count > files[lp.ListPos]
                lp.ListPos += 1
                if files[lp.ListPos] > 0
                    lp.Count = 1
                    lp.IsFile = false
                else
                    lp.ListPos += 1
                    if lp.ListPos == rp.ListPos
                        lp.FileId = rp.FileId
                        lp.Count = rp.Count
                    else
                        lp.FileId += 1
                        lp.Count = 1
                    end
                    lp.IsFile = true
                end
            end
        else
            cs += rp.FileId * filepos
            # println("R  $(rp.FileId)@$filepos  ->  $cs")
            rp.Count += 1
            if rp.Count > files[rp.ListPos]
                rp.FileId -= 1
                rp.ListPos -= 2
                rp.Count = 1
            end
            lp.Count += 1
            if lp.Count > files[lp.ListPos]
                lp.ListPos += 1
                lp.IsFile = true
                if lp.ListPos == rp.ListPos
                    lp.FileId = rp.FileId
                    lp.Count = rp.Count
                else
                    lp.FileId += 1
                    lp.Count = 1
                end
            end
        end
        filepos += 1
    end

    println("Checksum: $cs")
end

end # module Day09

# files = Day09.load_data("test.txt")
files = Day09.load_data("puzzle.txt")
# println(files)

aoc.print_day_header(9, "Disk Fragmenter")

Day09.part1(files)