
module computer

mutable struct Machine
    Ip :: Int64
    Regs :: Dict{String, Int32}
    Prog :: Vector{Int16}
    Output :: Vector{Int32}
end

get_operation(mach :: Machine) = mach.Prog[mach.Ip], mach.Prog[mach.Ip+1]

is_halted(mach :: Machine) = mach.Ip < 1 ||mach.Ip > length(mach.Prog)

function reset(mach :: Machine, regs)
    mach.Regs = regs
    mach.Ip = 1
    mach.Output = []
end

function get_combo_operand(mach :: Machine, raw_operand)
    if 0 <= raw_operand <= 3
        return raw_operand
    elseif raw_operand == 4
        return mach.Regs["A"]
    elseif raw_operand == 5
        return mach.Regs["B"]
    elseif raw_operand == 6
        return mach.Regs["C"]
    else
        println("ERROR combo operand with value 7 (invalid/reserved) encountered!")
    end
end

function run_prog(mach :: Machine)

    while !is_halted(mach)
        # println("IP: $(mach.Ip)")
        opcode, operand = get_operation(mach)
        op_res = instructions[opcode](mach, operand)
        mach.Ip = op_res
    end

end

function run_prog_with_target(mach :: Machine, target)

    next = 1

    while !is_halted(mach)
        # println("IP: $(mach.Ip)")
        opcode, operand = get_operation(mach)
        op_res = instructions[opcode](mach, operand)
        mach.Ip = op_res

        if opcode == 5
            if mach.Output[next] != target[next]
                # println("Wrong output: $(mach.Output)")
                return next - 1
            end
            next += 1
        end
    end

    return next
end


# The adv instruction (opcode 0) performs division. The numerator is the value in the A register.
# The denominator is found by raising 2 to the power of the instruction's combo operand. (So, an
# operand of 2 would divide A by 4 (2^2); an operand of 5 would divide A by 2^B.) The result of
# the division operation is truncated to an integer and then written to the A register.
function instr_adv(mach :: Machine, operand)
    # println("ADV operation")

    mach.Regs["A"] = mach.Regs["A"] ÷ 2^get_combo_operand(mach, operand)

    mach.Ip + 2
end

# The bxl instruction (opcode 1) calculates the bitwise XOR of register B and the instruction's
# literal operand, then stores the result in register B.
function instr_bxl(mach :: Machine, operand)
    # println("BXL operation")

    mach.Regs["B"] = mach.Regs["B"] ⊻ operand

    mach.Ip + 2
end

# The bst instruction (opcode 2) calculates the value of its combo operand modulo 8 (thereby
# keeping only its lowest 3 bits), then writes that value to the B register.
function instr_bst(mach :: Machine, operand)
    # println("BST operation")

    mach.Regs["B"] = get_combo_operand(mach, operand) % 8

    mach.Ip + 2
end

# The jnz instruction (opcode 3) does nothing if the A register is 0. However, if the A register
# is not zero, it jumps by setting the instruction pointer to the value of its literal operand;
# if this instruction jumps, the instruction pointer is not increased by 2 after this instruction.
function instr_jnz(mach :: Machine, operand)
    # println("JNZ operation")

    if mach.Regs["A"] == 0
        return mach.Ip + 2
    else
        # println("Using operand for jump: $operand")
        return operand + 1
    end
end

# The bxc instruction (opcode 4) calculates the bitwise XOR of register B and register C, then
# stores the result in register B. (For legacy reasons, this instruction reads an operand but
# ignores it.)
function instr_bxc(mach :: Machine, operand)
    # println("BXC operation")

    mach.Regs["B"] = mach.Regs["B"] ⊻ mach.Regs["C"]

    mach.Ip + 2
end

# The out instruction (opcode 5) calculates the value of its combo operand modulo 8, then outputs
# that value. (If a program outputs multiple values, they are separated by commas.)
function instr_out(mach :: Machine, operand)
    # println("OUT operation")

    op = get_combo_operand(mach, operand)
    push!(mach.Output, op % 8)
    # println("$(op % 8)")

    mach.Ip + 2
end

# The bdv instruction (opcode 6) works exactly like the adv instruction except that the result is
# stored in the B register. (The numerator is still read from the A register.)
function instr_bdv(mach :: Machine, operand)
    # println("BDV operation")

    mach.Regs["B"] = mach.Regs["A"] ÷ 2^get_combo_operand(mach, operand)

    mach.Ip + 2
end

# The cdv instruction (opcode 7) works exactly like the adv instruction except that the result is
# stored in the C register. (The numerator is still read from the A register.)
function instr_cdv(mach :: Machine, operand)
    # println("CDV operation")

    mach.Regs["C"] = mach.Regs["A"] ÷ 2^get_combo_operand(mach, operand)

    mach.Ip + 2
end

instructions = Dict(
    0 => instr_adv,
    1 => instr_bxl,
    2 => instr_bst,
    3 => instr_jnz,
    4 => instr_bxc,
    5 => instr_out,
    6 => instr_bdv,
    7 => instr_cdv
)

end
