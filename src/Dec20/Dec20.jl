module Dec20

using Combinatorics

struct Tile
    grid::Array{Bool, 2}
    id::String
    pos::Tuple{Int, Int}
    iscorner::Bool
end
Tile(x::String) = Tile.(split(x, "\n\n"))
Tile(x::Tile, pos, iscorner = false) = Tile(x.grid, x.id, pos, iscorner)

function Tile(x::SubString)
    id, image = split(x, ":\n")
    image = collect(join(split(image, "\n"))) .== '#'
    image = permutedims(reshape(image, 10, 10))
    Tile(image, id, (0, 0), false)
end

function Base.show(io::IO, m::Tile)
    println("ID : ", m.id)
    println("Position : ", m.pos)
    println("Is corner? : ", m.iscorner)
    display(m.grid)
    println("")
end

function find_corners(xs)
    adj_lst = [[[i.id for i in xs if b in borders(i) && i.id != x.id]
               for b in borders(x)]
               for x in xs]
    ind = [count(isempty.(i)) > 2 for i in adj_lst]
    corners = [i.id for i in xs][ind]
    [Tile(i.grid, i.id, i.pos, any(occursin.(i.id, corners))) for i in xs]
end

function borders(x::Tile)
    bs = [x.grid[1, :],
     x.grid[:, end],
     x.grid[end, :],
     x.grid[:, 1]]
    vcat(bs, reverse.(bs))
end

function valid_grid(g::Grid)
    if all(isnothing.(values(g)))
        return false
    else
        all(valid_tile(i, g) for (_, i) in g if !isnothing(i))
    end
end

function valid_tile(t::Tile, g::Grid)
    n = Int(sqrt(length(g)))
    adj = filter(x->!isnothing(g[x]), adjacent(t, n))
    all(check_edges(t, g[i]) for i in adj)
end

function adjacent(t::Tile, n)
    i, j = t.pos
    adj = [(i-1, j), (i+1, j), (i, j-1), (i, j+1)]
    adj = filter(x->all(x.<=n), adj)
    filter(x->all(x.>0), adj)
end

function check_edges(t::Tile, a::Tile)
    rel = a.pos .- t.pos
    if rel == (0, -1)
        t.grid[:, 1] == a.grid[:, end]
    elseif rel == (0, 1)
        t.grid[:, end] == a.grid[:, 1]
    elseif rel == (-1, 0)
        t.grid[1, :] == a.grid[end, :]
    elseif rel == (1, 0)
        t.grid[end, :] == a.grid[1, :]
    end
end

function conformations(t::Tile)
    x = t.grid
    cs = [x, x[end:-1:1, :], x[:, end:-1:1], x[end:-1:1, end:-1:1],
     x', x'[end:-1:1, :], x'[:, end:-1:1], x'[end:-1:1, end:-1:1]]
    [Tile(c, t.id, t.pos, t.iscorner) for c in cs]
end

function solve(xs)
    n = Int(sqrt(length(xs)))
    Grid = Dict{Tuple{Int, Int}, Union{Tile,Nothing}}
    g = Grid((i, j) => nothing for i in 1:n for j in 1:n)
    corners = [i for i in xs if i.iscorner]
    gs = Grid[]
    for i in vcat(conformations.(corners)...)
        gx = deepcopy(g)
        gx[(1, 1)] = Tile(i, (1, 1))
        push!(gs, gx)
    end
    tile_positions = [(i, j) for i in 1:n for j in 1:n if (i, j) != (1, 1)]

    for gi in gs
        positions = deepcopy(tile_positions)
        pos_filled = true
        while !isempty(positions)
            if !pos_filled
                break
            end
            p = popfirst!(positions)
            used = [i.id for (_, i) in gi if !isnothing(i)]
            tiles = [i for i in deepcopy(xs) if !(i.id in used)]
            pos_filled = false
            while !isempty(tiles) && !pos_filled
                t = pop!(tiles)
                t = Tile(t.grid, t.id, p, false)
                for c in conformations(t)
                    gi[p] = c
                    if valid_grid(gi)
                        pos_filled = true
                        break
                    else
                        gi[p] = nothing
                    end
                end
                isempty(tiles)
                pos_filled
            end
        end
    end

    complete = [g for g in gs if all(.!isnothing.(values(g)))]
end


function find_monsters(g::Grid)
    len = length(g)
    sqrt_len = Int(sqrt(len))
    shaved = Dict(i => j.grid[2:end-1, 2:end-1] for (i, j) in g)
    tile_positions = [(i, j) for i in 1:sqrt_len for j in 1:sqrt_len]
    ordered = [shaved[i] for i in tile_positions]
    horiz = [hcat(ordered[i:i+sqrt_len-1]...) for i in 1:Int(sqrt(len)):len]
    assembled = vcat(horiz...)

    n = Int(sqrt(length(assembled)))
    grid = fill('.', n, n)
    for i in 1:length(assembled)
        if assembled[i]
            grid[i] = '#'
        end
    end

    top = Regex("..................#.")
    mid = Regex("#....##....##....###")
    bot = Regex(".#..#..#..#..#..#...")
    monsters = 0
    for i in 1:n
        x = join(grid[i, :])
        ms = findall(mid, x)
        for m in ms
            if !isnothing(m)
                println(i)
                monsters += occursin(top, join(grid[i-1, m])) &&
                    occursin(bot, join(grid[i+1, m]))
            end
        end
    end
    monsters
end

input = read("src/Dec20/input.txt", String)
xs = Tile(input) |> find_corners;
gs = solve(xs);
monster_chars = sum(find_monsters.(gs)) * 15
sum(assembled) - monster_chars
