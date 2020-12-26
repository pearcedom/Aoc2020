module Dec14

function run!(x, version = 1)
    mem = Dict()
    mask = Dict()
    while !isempty(x)
        i = popfirst!(x)
        if occursin("mask", i)
            mask = parse_mask(i)
        else
            program = parse_program(i)
            if version == 1
                mem[program.addr] = setmask(program.val, mask)
            elseif version == 2
                addrs = setmask2(program.addr, mask)
                for addr in addrs
                    mem[addr] = program.val
                end
            end
        end
    end
    mem
end

function parse_mask(x)
    mask = replace(x, "mask = " => "")
    zeros = length(mask) .- findall(x->x == '0', mask) .+ 1
    ones = length(mask) .- findall(x->x == '1', mask) .+ 1
    xs = length(mask) .- findall(x->x == 'X', mask) .+ 1
    (ones = ones, zeros = zeros, xs = xs)
end

function parse_program(x)
    program = replace(x, "mem[" => "")
    program = replace(program, "]" => "")
    addr, val = split(program, " = ")
    (addr = parse(Int, addr), val = parse(Int, val))
end

function setmask(x, mask)
    for i in mask.ones
        x = set1(x, i)
    end
    for i in mask.zeros
        y = set0(x, i)
    end
    x
end

function setmask2(x, mask)
    for i in mask.ones
        x = set1(x, i)
    end
    float_xs(x, mask)
end

function float_xs(x, mask)
    out = []
    function inner(x, xs)
        xs = deepcopy(xs)
        if isempty(xs)
            return
        else
            i = pop!(xs)
            toggled = [x, toggle(x, i)]
            append!(out, toggled)
            [inner(a, xs) for a in toggled]
        end
    end
    inner(x, mask.xs)
    unique(out)
end

set1(x, n) = x | 2^(n-1)
set0(x, n) = x & ~(2^(n-1))
toggle(x, n) = x ⊻ 2^(n-1)

part1(x) = sum(values(run!(x, 1)))
part2(x) = sum(values(run!(x, 2)))


end

input = readlines("src/Dec14/input.txt")
@time part2(input)
