module aoclib

export print_day_header, print_part_header, load_singleline, load_multilines

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

function load_singleline(file_path)
    return read(file_path, String)
end

function load_multilines(file_path)
    file_content = read(file_path, String)
    lines = split(file_content, "\r\n")

    return lines
end

function load_multiline_blocks(file_path)
    file_content = read(file_path, String)
    all_lines = split(file_content, "\r\n")

    splitters = findall(s -> isempty(s), all_lines)
    # println(splitters)
    pushfirst!(splitters, 0)
    push!(splitters, length(all_lines)+1)

    res = []
    for i in 2:length(splitters)
        push!(res, all_lines[splitters[i-1]+1:splitters[i]-1])
    end

    # println(res)

    return res
end

end # module aoclib
