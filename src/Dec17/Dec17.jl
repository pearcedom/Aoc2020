module Dec17

mutable struct Cube
    state::Char
    i::Int
    j::Int
    k::Int
    adj::Int
end

struct PocketDimension
    cubes::Array{Cube, 3}
    ny::Int
    nx::Int
    nz::Int
end

function Base.show(io::IO, m::PocketDimension)
    mtx = fill('.', m.ny, m.nx, m.nz)
    for i in 1:m.ny, j in 1:m.nx, k in 1:m.nz
        mtx[j, i, k] = m.cubes[j, i, k].state
    end
    display(mtx)
end

function PocketDimension(x::Array{String, 1})
    n = length(x)
    x = vec(permutedims(reshape(collect(join(x)), n, n)))
    mtx = reshape(x, n, n, 1)
    mtx = convert(Array{Any, 3}, mtx)
    for i in 1:n, j in 1:n
        mtx[i, j, 1] = Cube(mtx[i, j, 1], i, j, 1, 0)
    end
    mtx = convert(Array{Cube, 3}, mtx)
    PocketDimension(mtx, n, n, 1)
end

function add_buffer(mtx::PocketDimension)
    x = deepcopy(mtx.cubes)

    i, j, k = size(x)
    back_empty = reshape(fill(Cube('.', 0, 0, 0, 0), i, j), i, j)
    for y in 1:i, x in 1:j
        c = back_empty[y, x]
        back_empty[y, x] = Cube(c.state, y, x, k+1, 0)
    end
    front_empty = reshape(fill(Cube('.', 0, 0, 0, 0), i, j), i, j)
    for y in 1:i, x in 1:j
        c = front_empty[y, x]
        front_empty[y, x] = Cube(c.state, y, x, 0, 0)
    end
    x = cat(front_empty, x, back_empty, dims = 3)

    i, j, k = size(x)
    out = []
    for z in 1:k
        m = x[:, :, z]
        top_row = [Cube('.', 0, col, z-1, 0) for col in 1:j]
        bottom_row = [Cube('.', i+1, col, z-1, 0) for col in 1:j]
        m = permutedims(cat(top_row, permutedims(m), bottom_row, dims = 2))
        left_col = [Cube('.', row, 0, z-1, 0) for row in 0:i+1]
        right_col = [Cube('.', row, j+1, z-1, 0) for row in 0:i+1]
        m = hcat(left_col, m, right_col)
        push!(out, m)
    end
    out = cat(out..., dims = 3)

    for i in 1:length(out)
        out[i] = Cube(out[i].state, out[i].i+1, out[i].j+1, out[i].k+1, 0)
    end
    PocketDimension(out, mtx.ny+2, mtx.nx+2, mtx.nz+2)
end

function adjacent(x::Cube, mtx)
    adj = [(x.i + i, x.j + j, x.k + k) for i in [-1, 0, 1], j in [-1, 0, 1], k in [-1, 0, 1]]
    adj = filter(c->c != (x.i, x.j, x.k), adj)
    adj = filter(c->all(c .> 0), adj)
    adj = filter(c->all(c .<= (mtx.ny, mtx.nx, mtx.nz)), adj)
    count(mtx.cubes[c...].state == '#' for c in adj)
end

function cycle_until(mtx::PocketDimension, until)
    n = 0
    while n < until
        mtx = cycle!(mtx)
        n += 1
    end
    mtx
end

function cycle!(mtx::PocketDimension)
    mtx = add_buffer(mtx)
    n_adj = adjacent.(mtx.cubes, Ref(mtx))
    for x in mtx.cubes
        if x.state == '#'
            x.state = n_adj[x.i, x.j, x.k] in [2, 3] ? '#' : '.'
        else
            x.state = n_adj[x.i, x.j, x.k] == 3 ? '#' : '.'
        end
    end
    mtx
end

function count_cubes(mtx::PocketDimension)
    n = 0
    for i in mtx.cubes
        if i.state == '#'
            n += 1
        end
    end
    n
end

part1(x) = count_cubes(cycle_until(PocketDimension(x), 6))

end

#-----------------------------

#input = readlines("src/Dec17/input.txt")
#part1(input)
