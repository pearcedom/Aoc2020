module Dec11

# This is really messy but I've done 2 game of lifes in the past year and I
# can't be bothered to tidy this one up. Shouldn't I be better at writing it
# neatly first go if I've already done it several times recently..?

mutable struct Seat
    state::Char
    j::Int
    i::Int
    adj::Int
end

struct WaitingRoom
    seats::Array{Seat, 2}
    nrow::Int
    ncol::Int
end

function WaitingRoom(x::Array)
    n, m = length(x), length(x[1])
    mtx = fill(Seat('.', 0, 0, 0), n, m)
    for i in 1:m, j in 1:n
        mtx[j, i] = Seat(x[j][i], j, i, 0)
    end
    WaitingRoom(mtx, n, m)
end

function Base.show(io::IO, m::WaitingRoom)
    mtx = fill('.', m.nrow, m.ncol)
    for i in 1:m.nrow, j in 1:m.ncol
        mtx[j, i] = m.seats[j, i].state
    end
    display(mtx)
end

function equilibrate!(mtx::WaitingRoom)
    states = []
    while
        !([i.state for i in mtx.seats] in states)
        push!(states, deepcopy([i.state for i in mtx.seats]))
        sit!(mtx)
    end
    mtx
end

function equilibrate2!(mtx::WaitingRoom)
    states = []
    while
        !([i.state for i in mtx.seats] in states)
        push!(states, deepcopy([i.state for i in mtx.seats]))
        sit2!(mtx)
    end
    mtx
end

function sit!(mtx::WaitingRoom)
    n_adj = adjacent.(mtx.seats, Ref(mtx))
    for x in mtx.seats
        if x.state == '.'
            continue
        else
            if n_adj[x.j, x.i] >= 4
                x.state = 'L'
            elseif n_adj[x.j, x.i] == 0
                x.state = '#'
            end
        end
    end
    mtx
end

function adjacent(x::Seat, mtx)
    adj = [(x.j + i, x.i + j) for i in [-1, 0, 1], j in [-1, 0, 1]]
    adj = filter(c->c != (x.j, x.i), adj)
    adj = filter(c->all(c .> 0), adj)
    adj = filter(c->all(c .<= (mtx.nrow, mtx.ncol)), adj)
    count(mtx.seats[c...].state == '#' for c in adj)
end

function sit2!(mtx::WaitingRoom)
    n_adj = superadjacent.(mtx.seats, Ref(mtx))
    for x in mtx.seats
        if x.state == '.'
            continue
        else
            if n_adj[x.j, x.i] >= 5
                x.state = 'L'
            elseif n_adj[x.j, x.i] == 0
                x.state = '#'
            end
        end
    end
    mtx
end

function superadjacent(x::Seat, mtx)
    adj = vcat(
        [[(i.j, i.i) for i in mtx.seats[:, x.i] if i.j >= x.j]],
        [reverse([(i.j, i.i) for i in mtx.seats[:, x.i] if i.j <= x.j])],
        [[(i.j, i.i) for i in mtx.seats[x.j, :] if i.i >= x.i]],
        [reverse([(i.j, i.i) for i in mtx.seats[x.j, :] if i.i <= x.i])],
        [get_diag(x.i, x.j, 1, 1)],
        [get_diag(x.i, x.j, 1, -1)],
        [get_diag(x.i, x.j, -1, 1)],
        [get_diag(x.i, x.j, -1, -1)]
    )
    n = 0
    for i in adj
        filter!(c->c != (x.j, x.i), i)
        filter!(c->c != (x.j, x.i), i)
        filter!(c->all(c .> 0), i)
        filter!(c->all(c .<= (mtx.nrow, mtx.ncol)), i)
        #println(any(mtx.seats[c...].state == '#' for c in i))
        char = ""
        for c in i
            if mtx.seats[c...].state != '.'
                char = mtx.seats[c...].state
                break
            end
        end
        n += char == '#'
    end
    n
end

function get_diag(i, j, di, dj)
    v = []
    while i < mtx.ncol + 1 && i > 0 && j < mtx.nrow + 1 && j > 0
        i += di
        j += dj
        push!(v, (j, i))
    end
    v
end

part1(x) = count(i.state == '#' for i in equilibrate!(WaitingRoom(x)).seats)
part2(x) = count(i.state == '#' for i in equilibrate2!(WaitingRoom(x)).seats)

end

input = readlines("src/Dec11/input.txt")
mtx = WaitingRoom(input)
sit!(mtx)
sit2!(mtx)
x = mtx.seats[1, 4]

part1(input)
part2(input)

