module Dec03

function input2mtx(input)
    n = length(input)
    m = length(input[1])

    mtx = zeros(Int, n, m)
    for i in 1:n
        for j in 1:m
            mtx[i, j] = input[i][j] == '.' ? 0 : 1
        end
    end
    mtx
end

function n_trees(mtx, step)
    i, j = (1, 1)
    total = 0
    n, m = size(mtx)
    while i <= n
        total += mtx[i, j]
        i = i + step[1]
        j = mod1(j + step[2], m)
    end
    total
end

part1(mtx) = n_trees(mtx, (1, 3))
part2(mtx, steps) = prod(n_trees.(Ref(mtx), steps))

end

# using BenchmarkTools
# mtx = readlines("src/Dec03/input.txt") |> input2mtx
# steps = [(1, 1), (1, 3), (1, 5), (1, 7), (2, 1)]
# @btime part1(mtx)
# @btime part2(mtx, steps)
