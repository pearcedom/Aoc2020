module Dec17

mutable struct Cube
    state::Char
    i::Int
    j::Int
    k::Int
    l::Int
    adj::Int
end

struct PocketDimension
    cubes::Array{Cube, 4}
    ny::Int
    nx::Int
    nz::Int
    na::Int
end

function Base.show(io::IO, m::PocketDimension)
    mtx = fill('.', m.ny, m.nx, m.nz, m.na)
    for i in 1:m.ny, j in 1:m.nx, k in 1:m.nz, l in 1:m.na
        mtx[j, i, k, l] = m.cubes[j, i, k, l].state
    end
    display(mtx)
end

function PocketDimension(x::Array{String, 1})
    n = length(x)
    x = vec(permutedims(reshape(collect(join(x)), n, n)))
    mtx = reshape(x, n, n, 1, 1)
    mtx = convert(Array{Any, 4}, mtx)
    for i in 1:n, j in 1:n
        mtx[i, j, 1, 1] = Cube(mtx[i, j, 1, 1], i, j, 1, 1, 0)
    end
    mtx = convert(Array{Cube, 4}, mtx)
    PocketDimension(mtx, n, n, 1, 1)
end


b = x[:, :, :, 1]
b = x[:, :, :, 2]
b = x[:, :, :, 3]

function add_buffer(mtx::PocketDimension)
    x = deepcopy(mtx.cubes)

    i, j, k, l = size(x)
    out4 = []
    for a in 1:l
        i, j, k, l = size(x)
        b = x[:, :, :, a]
        back_empty = reshape(fill(Cube('.', 0, 0, 0, 0, 0), i, j), i, j)
        for y in 1:i, x in 1:j
            c = back_empty[y, x]
            back_empty[y, x] = Cube(c.state, y, x, k+1, a, 0)
        end
        front_empty = reshape(fill(Cube('.', 0, 0, 0, 0, 0), i, j), i, j)
        for y in 1:i, x in 1:j
            c = front_empty[y, x]
            front_empty[y, x] = Cube(c.state, y, x, 0, a, 0)
        end
        b = cat(front_empty, b, back_empty, dims = 3)

        i, j, k = size(b)
        out3 = []
        for z in 1:k
            m = b[:, :, z]
            top_row = [Cube('.', 0, col, z-1, a, 0) for col in 1:j]
            bottom_row = [Cube('.', i+1, col, z-1, a, 0) for col in 1:j]
            m = permutedims(cat(top_row, permutedims(m), bottom_row, dims = 2))
            left_col = [Cube('.', row, 0, z-1, a, 0) for row in 0:i+1]
            right_col = [Cube('.', row, j+1, z-1, a, 0) for row in 0:i+1]
            m = hcat(left_col, m, right_col)
            push!(out3, m)
        end
        out3 = cat(out3..., dims = 3)

        push!(out4, out3)
    end
    out4 = cat(out4..., dims = 4)

    i, j, k, l = size(x)
    front4 = deepcopy(out4[:, :, :, 1])
    for i in 1:length(front4)
        front4[i] = Cube('.', front4[i].i, front4[i].j, front4[i].k, 0, 0)
    end

    back4 = deepcopy(out4[:, :, :, 1])
    for i in 1:length(back4)
        back4[i] = Cube('.', back4[i].i, back4[i].j, back4[i].k, l+1, 0)
    end

    out = cat(front4, out4, back4, dims = 4)

    for i in 1:length(out)
        out[i] = Cube(out[i].state, out[i].i+1, out[i].j+1, out[i].k+1, out[i].l+1, 0)
    end
    PocketDimension(out, mtx.ny+2, mtx.nx+2, mtx.nz+2, mtx.na+2)
end

function adjacent(x::Cube, mtx)
    adj = [(x.i + i, x.j + j, x.k + k, x.l + l) for
           i in [-1, 0, 1],
           j in [-1, 0, 1],
           k in [-1, 0, 1],
           l in [-1, 0, 1]]
    adj = filter(c->c != (x.i, x.j, x.k, x.l), adj)
    adj = filter(c->all(c .> 0), adj)
    adj = filter(c->all(c .<= (mtx.ny, mtx.nx, mtx.nz, mtx.na)), adj)
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
        println(x)
        if x.state == '#'
            x.state = n_adj[x.i, x.j, x.k, x.l] in [2, 3] ? '#' : '.'
        else
            x.state = n_adj[x.i, x.j, x.k, x.l] == 3 ? '#' : '.'
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

part2(x) = count_cubes(cycle_until(PocketDimension(x), 6))

end

#-----------------------------

#input = readlines("src/Dec17/input.txt")
#part2(input)
