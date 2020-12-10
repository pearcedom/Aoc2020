module Dec06

function parse_input(input)
    input[1:end-1] |> # why is that terminal newline there??
        x -> split(x, "\n\n") |>
        x -> [split(i, "\n") for i in x]
end

part1(x) = sum(length(reduce(∪, i)) for i in x)
part2(x) = sum(length(reduce(∩, i)) for i in x)

end

# input = parse_input(read("src/Dec06/input.txt", String))
# part1(input)
# part2(input)
