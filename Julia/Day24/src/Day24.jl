import aoclib as aoc

module Day24

import aoclib as aoc

struct Gate
    in1 :: String
    in2 :: String
    out :: String
    op
end

function load_data(file_path)
    blocks = aoc.io.load_multiline_blocks(file_path)
    gates = blocks[2]

    # x00: 1
    init_values = Dict()
    for l in blocks[1]
        p = split(l, ": ")
        init_values[p[1]] = parse(Int16, p[2])
    end

    # ntg XOR fgs -> mjb
    gates = []
    for l in blocks[2]
        tokens = split(l)
        op = if tokens[2] == "AND"
            &
        elseif tokens[2] == "OR"
            |
        elseif tokens[2] == "XOR"
            xor
        # else
        #     println("ERROR unknown operator in gates defintion")
        end
        push!(gates, Gate(tokens[1], tokens[3], tokens[5], op))
    end


    init_values, gates
end

mutable struct State
    in1_val :: Int16
    in2_val :: Int16
    out_val :: Int16
end

function part1(init_values, gates)
    aoc.print_part_header(1, "Value of zXXX")

    ins, names = analyze_gates_part1(gates)
    # println("Ins: $ins")
    # println("Names: $names")
    states = [State(-1, -1, -1) for g in gates]
    values = copy(init_values)
    to_propagate = collect(keys(init_values))

    while length(to_propagate) > 0
        next = popfirst!(to_propagate)
        if !haskey(ins, next)
            continue
        end
        targets = ins[next]
        for t in targets
            ti = names[t]
            tgate = gates[ti]
            tstate = states[ti]
            # println("Setting $next in $tgate")
            set_in_part1(tgate, tstate, next, values[next])
            # println("  New state: $tstate")
            if tstate.in1_val >= 0 && tstate.in2_val >= 0
                tstate.out_val = tgate.op(tstate.in1_val, tstate.in2_val)
                # println("  All inputs in, new out: $(tstate.out_val)")
                values[tgate.out] = tstate.out_val
                push!(to_propagate, t)
            end
        end
    end

    zgates = sort(collect(filter(n -> startswith(n, "z"), keys(values))), rev=true)
    println(zgates)
    bits = [values[z] for z in zgates]
    println(bits)
    number = join(bits)
    println(number)

    res = parse(Int64, number, base=2)

    println("Z: $res")
end

function set_in_part1(gate, state, in_name, in_value)
    if gate.in1 == in_name
        state.in1_val = in_value
    elseif gate.in2 == in_name
        state.in2_val = in_value
    else
        println("ERROR impossible situation, try to set not-existing input $in_name for gate")
    end
end

function analyze_gates_part1(gates)
    ins = Dict()
    names = Dict()

    for i in eachindex(gates)
        g = gates[i]
        names[g.out] = i
        if haskey(ins, g.in1)
            push!(ins[g.in1], g.out)
        else
            ins[g.in1] = [g.out]
        end
        if haskey(ins, g.in2)
            push!(ins[g.in2], g.out)
        else
            ins[g.in2] = [g.out]
        end
    end

    ins, names
end

end # module Day24

# init_values, gates = Day24.load_data("test.txt")
init_values, gates = Day24.load_data("puzzle.txt")
# println(init_values)
# println(gates)


aoc.print_day_header(24, "")

Day24.part1(init_values, gates)
