module Dec24

struct Hex
    x
    y
    z
end
Hex() = Hex(0, 0, 0)

e(x::Hex) = Hex(x.x+1, x.y-1, x.z)
se(x::Hex) = Hex(x.x, x.y-1, x.z+1)
sw(x::Hex) = Hex(x.x-1, x.y, x.z+1)
w(x::Hex) = Hex(x.x-1, x.y+1, x.z)
nw(x::Hex) = Hex(x.x, x.y+1, x.z-1)
ne(x::Hex) = Hex(x.x+1, x.y, x.z-1)

function parse_input(p)
    p = collect(p)
    ps = Symbol[]
    while !isempty(p)
        c = popfirst!(p)
        c == 'n' || c == 's' ? c = vcat(c, popfirst!(p)) : c
        push!(ps, Symbol(join(c)))
    end
    ps
end

function move(routes::Array{Array{Symbol, 1}, 1})
    d = Dict()
    for route in routes
        move(route, d)
    end
    d
end

function move(route::Array{Symbol, 1}, d::Dict)
    h = Hex()
    for i in route
        h = getfield(Main, i)(h)
    end
    flip!(h, d)
end

function flip!(x::Hex, d::Dict)
    if !(x in keys(d))
        d[x] = "black"
    else
        delete!(d, x)
    end
    d
end

function day!(d::Dict, lim)
    if lim == 0 return d end
    tiles = vcat(adjacent.(keys(d), Ref(d))...)
    for t in tiles
        if !(t in keys(d))
            d[t] = "white"
        end
    end
    n_adj = n_adjacent.(keys(d), Ref(d))
    for (h, n) in n_adj
        col = d[h]
        if col == "black" && !(n in [1, 2])
            delete!(d, h)
        elseif col == "white" && n == 2
            d[h] = "black"
        elseif col == "white"
            delete!(d, h)
        end
    end
    day!(d, lim-1)
end

function n_adjacent(x::Hex, d::Dict)
    adj = adjacent(x, d)
    adj = adj[adj .∈ Ref(keys(d))]
    x, count(d[i] == "black" for i in adj)
end

function adjacent(x::Hex, d::Dict)
    adj = [
        Hex(x.x+1, x.y, x.z-1),
        Hex(x.x+1, x.y-1, x.z),
        Hex(x.x, x.y-1, x.z+1),
        Hex(x.x-1, x.y, x.z+1),
        Hex(x.x-1, x.y+1, x.z),
        Hex(x.x, x.y+1, x.z-1)
    ]
end

part1(x) = length(move(parse_input.(x)))
part2(x) = count(values(day!(move(parse_input.(x)), 100)) .== "black")

end

#-----------------------------

input = readlines("src/Dec24/input.txt")
part1(input)
@time part2(input, 100)
