module Dec05

function input2binary(x)
    x = replace(x, r"[FL]" => "0")
    replace(x, r"[BR]" => "1")
end

seat_id(x) = parse(Int, input2binary(x), base = 2)

function find_seat(x)
    sort!(x)
    i = argmax(diff(x))
    x[i] + 1
end


part1(x) = maximum(seat_id.(x))
part2(x) = find_seat(seat_id.(x))


end

# x = readlines("src/Dec05/input.txt")
#
# using BenchmarkTools
# @btime part1(x)
# @btime part2(x)


