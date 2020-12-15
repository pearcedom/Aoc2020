module Dec13


"""
2  3  5    t=0

2
   3
2
      5
2  3

2
   3
2     5
"""

function part1(target, times)
    times = filter(!isnothing, times)
    times_mod = [target % i for i in times]
    min_diff, mindex = findmin(times .- times_mod)
    min_diff * times[mindex]
end


function part2(times)
    x = collect(enumerate(times))
    filter!(i->!isnothing(i[2]), x)
    x = [(i[1] - 1, i[2]) for i in x]

    n = 0
    inc = x[1][2]

    for l in 2:length(x)
        y = x[1:l]
        found = false
        while !found
            for (i, j) in y
                if (n + i) % j == 0
                    found = true
                else
                    found = false
                    n += inc
                    break
                end
            end
        end
        inc = lcm([i for (_, i) in y])
    end
    n
end

end

#-----------------------------

target, times = readlines("src/Dec13/input.txt")
target = parse(Int, target)
times = tryparse.(Int, split(times, ","))

part1(target, times)
@time part2(times)


