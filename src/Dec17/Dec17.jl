module Dec17

input = readlines("src/Dec17/example.txt")
x = copy(input)

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

function PocketDimension(x::Array)
    n = length(x)
    x = vcat(fill('.', n^2), collect(join(x)), fill('.', n^2))
    mtx = reshape(x, n, n, n)
    for i in 1:n, j in 1:n, k in 1:n
        mtx[j, i, 2] = Cube(x[j][i][k], j, i, k, 0)
    end
    PocketDimension(mtx, n, m, 3)
end

x = input
mtx = PocketDimension(input)
x = mtx.cubes[2, 2, 2]

function adjacent(x::Cube, mtx)
    adj = [(x.i + i, x.j + j, x.k + k) for i in [-1, 0, 1], j in [-1, 0, 1], k in [-1, 0, 1]]
    adj = filter(c->c != (x.i, x.j, x.k), adj)
    adj = filter(c->all(c .> 0), adj)
    adj = filter(c->all(c .<= (mtx.ny, mtx.nx, mtx.nz)), adj)
    count(mtx.cubes[c...].state == '#' for c in adj)
end


function cycle!(mtx::PocketDimension)
    n_adj = adjacent.(mtx.cubes, Ref(mtx))
    for x in mtx.cubes
        if x.state == '#'
            n_adj[x.i, x.j, x.k] in [2, 3] ? x.state = '.' : continue
        else
            n_adj[x.i, x.j, x.k] == 3 ? x.state = '#' : continue
        end
    end
    mtx
end

cycle!(mtx)







end
