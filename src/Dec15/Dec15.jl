module Dec15

function play(x, lim)
    i = length(x)
    n = pop!(x)
    d = Dict{Int64, Int64}((j, i) for (i, j) in enumerate(x))
    while i < lim
        d, n, i = speak!(d, n, i)
    end
    n
end

function speak!(d, n, i)
    next = haskey(d, n) ? i - d[n] : 0
    d[n] = i
    d, next, i+1
end

part1(x) = play(x, 2020)
part2(x) = play(x, 30000000)

end

using BenchmarkTools
@time part1([14, 8, 16, 0, 1, 17])
@btime part2([14, 8, 16, 0, 1, 17])
