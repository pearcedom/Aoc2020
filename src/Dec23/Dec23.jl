module Dec23

function crabcups(cups::Array, moves)
    i = 1
    move = 1
    while move <= moves
        cup = cups[i]
        pickup = pickup!(cups, i)
        destination = insert_at(cups, cup)
        for p in reverse(pickup)
            insert!(cups, destination, p)
        end
        i = mod1(findfirst(x->x == cup, cups) + 1, 9)
        move += 1
    end
    i1 = findfirst(x->x == 1, cups)
    cups = vcat(cups[i1+1:end], cups[1:i1-1])
    parse(Int, join(cups))
end

crabcups(cups::Int, moves) = crabcups(reverse(digits(cups)), moves)

function insert_at(cups, val)
    j = nothing
    val = mod1(val - 1, 9)
    while isnothing(j)
        j = findfirst(x->x == val, cups)
        val = mod1(val - 1, 9)
    end
    j + 1
end

function pickup!(cups, i)
    i+1:minimum([i+3, 9])
    x = splice!(cups, i+1:minimum([i+3, 9]))
    y = splice!(cups, 1:i+3-9)
    vcat(x, y)
end

end

part1(x) = crabcups(x, 100)
part1(418976235)
