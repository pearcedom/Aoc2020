module Dec23

function crabcups(cups::Dict, cup, moves)
    lim = maximum(keys(cups))
    move = 1
    while move <= moves
        next = pickup(cups, cup)
        destination = insert_at(cup, next, lim)
        cups[cup] = cups[next[3]]
        cups[next[3]] = cups[destination]
        cups[destination] = next[1]
        cup = cups[cup]
        move += 1
    end
    cups
end

function crabcups(cups::String, moves, part2 = false)
    cups = parse.(Int, collect(cups))
    cup = cups[1]
    cups = part2 ? vcat(cups, 10:Int(1e6)) : cups
    cups = populate(cups)
    crabcups(cups, cup, moves)
end

function pickup(cups::Dict, cup)
    a = cups[cup]
    b = cups[a]
    c = cups[b]
    [a, b, c]
end

function insert_at(cup, next, lim)
    cup = mod1(cup - 1, lim)
    while cup in next
        cup = mod1(cup - 1, lim)
    end
    cup
end

function populate(input)
    lim = maximum(input)
    cups = Dict()
    for (i, j) in enumerate(input)
        cups[j] = input[mod1(i+1, lim)]
    end
    cups
end

function unlink(x, i)
    lim = maximum(keys(x))
    out = []
    while length(out) < lim
        i = x[i]
        push!(out, i)
    end
    join(out)
end

part1(x) = unlink(crabcups(x, 100), 1)[1:end-1]
function part2(x)
    cups = crabcups(x, 10000001, true)
    cups[1] * cups[cups[1]]
end

end

# part1("418976235")
# part2("418976235")
