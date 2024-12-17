module matrix

function convert_stringarray_to_matrix(lines)
    return reduce(vcat, permutedims.(collect.(lines)))
end

is_inside(mapsize, pos) = pos[1] > 0 && pos[2] > 0 && pos[1] <= mapsize[1] && pos[2] <= mapsize[2]

g_at(pos::Vector{Int64}, map) = map[pos[1], pos[2]]

s_at(pos::Vector{Int64}, map, value) = map[pos[1], pos[2]] = value

function find(grid :: Matrix{Char}, symb)
    gs = size(grid)
    for r ∈ 1:gs[1], c ∈ 1:gs[2]
        if grid[r, c] == symb
            return [r, c]
        end
    end

    nothing
end

sym2dir = Dict('^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1])

rotMathLeft = [0 -1; 1 0]
rotMathRight = [0 1; -1 0]

manhattan_dist(p1, p2) = sum(abs.(p1 - p2))

end