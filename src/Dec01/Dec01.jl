module Dec01

using Combinatorics

function dec01(x::Array{Int}, n::Int)
    combs = combinations(x, n)
    for i in combs
        if sum(i) == 2020
            return prod(i)
        end
    end
end

part1(x) = dec01(x, 2)
part2(x) = dec01(x, 3)

end

#input =
#    """1721
#    979
#    366
#    299
#    675
#    1456"""
#x = parse.(Int, split(input, "\n"))

# x = parse.(Int, readlines("src/Dec01/part1.txt"))
# @btime part1_quick(x)
# @btime part2(x)
