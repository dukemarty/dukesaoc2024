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

end # module aoclib
