module Dec02

struct Password
    pass::String
    required::Char
    limits::Array{Int}
end

function parse_input(input)
    parsed = split.(input, " ")
    clean_input.(parsed)
end

function clean_input(x)
    pass = x[3]
    required = Char(x[2][1])
    limits = parse.(Int, split(x[1], "-"))
    Password(pass, required, limits)
end

function valid(x::Password, shop)
    if shop == "sled"
        n = sum(collect(x.pass) .== x.required)
        n in UnitRange(x.limits...)
    elseif shop == "taboggan"
        i, j = x.limits
        xor(x.pass[i] == x.required, x.pass[j] == x.required)
    end
end

part1(x) = sum(valid.(x, "sled"))
part2(x) = sum(valid.(x, "taboggan"))

end

#using BenchmarkTools
#input = readlines("src/Dec02/Dec02.txt")
#x = parse_input(input)
#@btime part1(x)
#@btime part2(x)

