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

include("aocio.jl")

include("aocmatrix.jl")

end # module aoclib
