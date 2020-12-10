module Dec09

using Combinatorics

function find_flaw(input, n, i = 1)
    x, y = input[i:i+n-1], input[i+n:end]
    cs = combinations(x, 2)
    if count(sum.(cs) .== y[1]) > 0
        find_flaw(input, n, i+1)
    else
        return y[1]
    end
end

function exploit_flaw(input, target, i = 1)
    input[i]
    for j in 2:length(input)
        s = sum(input[i:j])
        if s == target
            seq = input[i:j]
            return minimum(seq) + maximum(seq)
        elseif s > target
            break
        end
    end
    exploit_flaw(input, target, i+1)
end

part1(x) = find_flaw(x, 25)
part2(x) = exploit_flaw(x, find_flaw(x, 25))

end

# input = readlines("src/Dec09/input.txt")
# input = parse.(Int, input)
# using BenchmarkTools
# part1(input)
# @btime part2(input)


