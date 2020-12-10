module Day8

mutable struct Instruction
    op::String
    value::Int
end

mutable struct Program
    ops::Array{Instruction}
    pos::Int
    path::Array{Int}
    acc::Int
end
Program(x::Array{Instruction}) = Program(x, one(1), [], zero(Int))

parse2Program(x) = Program(parse2Instruction.(x))

function parse2Instruction(x)
    op, value = split(x, " ")
    Instruction(op, parse(Int, value))
end

function operate(x::Program)
    if x.pos in 1:length(x.ops)
        pos, inc = operate(x.ops[x.pos])
        push!(x.path, x.pos)
        x.acc += inc
        x.pos += pos
    else
        return x
    end

    if x.pos in x.path
        return x
    else
        operate(x)
    end
end

function operate(x::Instruction)
   if x.op == "nop"
       return 1, 0
   elseif x.op == "acc"
       return 1, x.value
   elseif x.op == "jmp"
       return x.value, 0
   end
end

function fix(x::Program)
    potentials = [i for i in x.path if x.ops[i].op != "acc"]
    for i in potentials
        y = refresh(x)
        y.ops[i].op = y.ops[i].op == "jmp" ? "nop" : "jmp"
        y = operate(y)
        if y.pos > length(y.ops)
            return y
        end
    end
end

function refresh(x::Program)
    new = deepcopy(x)
    new.pos = 1
    new.path = []
    new.acc = 0
    new
end

part1(x) = operate(parse2Program(x)).acc
part2(x) = fix(operate(parse2Program(x))).acc

end

########

# input = readlines("src/Dec08/input.txt");
# x = parse2Program(input)
# part1(input)
# part2(input)
