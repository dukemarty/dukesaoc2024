import aoclib as aoc

module Day05

import aoclib as aoc

function load_data(file_path)

    blocks = aoc.load_multiline_blocks(file_path)
    raw_rules = map(l -> map(t -> parse(UInt32, t), split(l, "|")), blocks[1])
    rule_keys = Set(map(p -> p[1], raw_rules))
    rules = Dict([(r, map(p -> p[2], raw_rules[findall(p -> p[1] == r, raw_rules)])) for r in rule_keys])
    orders = map(l -> map(t -> parse(UInt32, t), split(l, ",")) ,blocks[2])

    return rules, orders
end

function part1(rules, orders)
    aoc.print_part_header(1, "Sum of middle page in correct orders")

    res = 0
    for o in orders
        if check_order_correctness_part1(o, rules)
            res += o[(1 + length(o)÷2)]
        end
    end

    println("The sum of the middle page numbers: $res")
end

function part2(data)
    aoc.print_part_header(2, "")

end

function check_order_correctness_part1(order, rules)
    for i in eachindex(order)
        for e in order[1:i-1]
            if !haskey(rules, order[i])
                continue
            end
            if e ∈ rules[order[i]]
                return false
            end
        end
    end

    return true
end

end # module Day05

# rules, print_orders = Day05.load_data("test.txt")
rules, print_orders = Day05.load_data("puzzle.txt")
# println("Rules: $rules")
# println("Print orders: $print_orders")

aoc.print_day_header(5, "Print Queue")

Day05.part1(rules, print_orders)

# Day05.part2(data)
