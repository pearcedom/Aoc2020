module Dec19

function parse_input(input)
    split_by = findfirst(x->x .== "", input)
    rules, messages = input[1:split_by-1], input[split_by+1:end]
    rules = Dict(i => replace(j, "\"" => "") for (i, j) in split.(rules, ": "))
    rules = Dict(i => " $j " for (i, j) in rules)
    messages, rules
end

function check_messages(messages, rules)
    x = regex0(rules)
    messages[occursin.(x, messages)]
end

function regex0(r)
    x = deepcopy(r["0"])
    while !isnothing(match(r"\d", x))
        for i in eachmatch(r"\d+", x)
            x = replace(x, " $(i.match) " => " ($(r[i.match])) ", count = 1)
        end
        x
    end
    Regex("^$(replace(x, " " => ""))\$")
end

function rerule(messages, rules)
    x = rules["8"]
    c = [x]
    for i in 1:3
        push!(c, c[end] * x)
    end
    rules["8"] = join(c, "|")
    x = rules["11"]
    c = [x]
    for i in 1:3
        push!(c, replace(c[end], r" (42) (31) " => s" \1 \1 \2 \2 "))
    end
    rules["11"] = join(c, "|")
    messages, rules
end

part1(x) = length(check_messages(parse_input(input)...))
part2(x) = length(check_messages(rerule(parse_input(input)...)...))

input = readlines("src/Dec19/example2.txt")
@time part1(input)
@time part2(input)
