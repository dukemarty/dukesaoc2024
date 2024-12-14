import aoclib as aoc

module Day09

import aoclib as aoc

mutable struct Pointer
    FileId::Int32
    ListPos::Int32
    Count::Int32
    IsFile::Bool
end

function load_data(file_path)
    line = aoc.load_singleline(file_path)

    return map(c -> parse(Int16, string(c)), collect(line))
end

function part1(files)
    aoc.print_part_header(1, "New Checksum #1")

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

struct File
    Id::Int32
    Size::Int32
end

mutable struct FillSlot
    Remaining :: Int32
    Files :: Vector{File}
end

function part2(files)
    aoc.print_part_header(2, "New Checksum #2")

    # move files from the end, if possible
    moved = Set()
    filled = Dict{Int32, FillSlot}()
    rp = Pointer(length(files) ÷ 2, length(files), 1, true)
    while rp.ListPos > 1
        slot = find_free_enough_slot(rp.ListPos, files, filled)
        if (slot > 0)
            if haskey(filled, slot)
                push!(filled[slot].Files, File((rp.ListPos - 1) ÷ 2, files[rp.ListPos]))
                filled[slot].Remaining -= files[rp.ListPos]
            else
                filled[slot] = FillSlot(files[slot] - files[rp.ListPos], [File((rp.ListPos - 1) ÷ 2, files[rp.ListPos])])
            end
            push!(moved, rp.ListPos)
        end
        rp.ListPos -= 2
    end
    # println("Filled: $filled")
    # println("Moved: $moved")

    # calculate checksum
    cs = 0
    filepos = 0
    is_file = true
    for pos ∈ eachindex(files)
        if is_file
            if pos in moved
                # println("Skipping original #$((pos-1)÷2) @$pos")
                filepos += files[pos]
                is_file = !is_file
                continue
            end
            id = (pos-1) ÷ 2
            # println("Processing #$id @$pos")
            for i ∈ 1:files[pos]
                cs += filepos * id
                # println("  + $filepos * $id (filepos*id)")
                filepos += 1
            end
        else
            if haskey(filled, pos)
                for f in filled[pos].Files
                    # println("Working on $f")
                    # println("Processing #$(f.Id) @$pos")
                    for i ∈ 1:f.Size
                        cs += filepos * f.Id
                        # println("  + $filepos * $(f.Id) (filepos*id)")
                        filepos += 1
                    end
                end
                filepos += filled[pos].Remaining
            else 
                filepos += files[pos]
            end
        end

        is_file = !is_file
    end

    println("Checksum: $cs")
end

function find_free_enough_slot(file, files, filled)
    len = files[file]
    for s ∈ 2:2:(file-1)
        if haskey(filled, s)
            if filled[s].Remaining >= len
                return s
            end
        else
            if files[s] >= len
                return s
            end
        end
    end

    return 0
end

end # module Day09

# files = Day09.load_data("test.txt")
files = Day09.load_data("puzzle.txt")
# println(files)

aoc.print_day_header(9, "Disk Fragmenter")

Day09.part1(files)

Day09.part2(files)
