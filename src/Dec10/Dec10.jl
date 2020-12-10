module Dec10

using Memoize

function part1(input)
    diffs = sort(input) |> diff
    (count(diffs .== 3) + 1) * (count(diffs .== 1) + 1)
end

function possible_combinations(input)
    seq = sorted = vcat(0, sort(input), maximum(input)+3)
    @memoize Dict function backtrack(seq)
        if length(seq) == 1
            return 1
        else
            seq = copy(seq)
            i = popfirst!(seq)
            subseq = seq[(seq .- i) .<= 3]
            reduce(+, backtrack(seq[j:end]) for j in 1:length(subseq))
        end
    end
    backtrack(sorted)
end
part2(x) = possible_combinations(x)

end

input = [parse(Int, i) for i in eachline("src/Dec10/input.txt")];
part1(input)
part2(input)
