module Dec16

function parse_rules(x)
    x = split.(split(x, "\n"), ": ")
    rules = Dict()
    for (key, vals) in x
        v = split.(split(vals, " or "), "-")
        v = [collect(UnitRange(parse.(Int, i)...)) for i in v]
        rules[String(key)] = vcat(v...)
    end
    rules
end

function parse_tickets(x)
    x = split(x, "\n")[2:end-1]
    [parse.(Int, split(i, ",")) for i in x]
end

function parse_myticket(x)
    x = split(x, "\n")[2]
    parse.(Int, split(x, ","))
end

function invalid_values(tickets, rules)
    any_rules = unique(vcat(values(rules)...))
    any_tickets = vcat(tickets...)
    invalid = []
    for i in any_tickets
        if !any(i ∈ any_rules)
            push!(invalid, i)
        end
    end
    invalid
end

function departure_index(tickets, rules)
    d = index_fields(tickets, rules)
    [j[1] for (i, j) in d if occursin("departure", i)]
end

function index_fields(tickets, rules)
    x = valid_tickets(tickets, rules)
    dmap = Dict(i => [] for i in keys(rules))
    i = 1
    while !isempty(x[1])
        p = popfirst!.(x)
        for (key, val) in rules
            if all(p .∈ Ref(val))
                dmap[key] = append!(dmap[key], [i])
            end
        end
        i += 1
    end

    while any(length.(values(dmap)) .!= 1)
        definite = vcat([j for (_, j) in dmap if length(j) == 1]...)
        for (key, val) in dmap
            if length(val) > 1
                dmap[key] = val[.!(val .∈ Ref(definite))]
            end
        end
    end
    dmap
end

function valid_ticket(ticket, rules)
    any_rules = vcat(values(rules)...)
    all(ticket .∈ Ref(any_rules))
end

valid_tickets(tickets, rules) = filter(x->valid_ticket(x, rules), tickets)

part1(x, y) = sum(invalid_values(parse_tickets(x), parse_rules(y)))
part2(x, y, z) = prod(parse_myticket(z)[departure_index(parse_tickets(x), parse_rules(y))])

end

#-----------------------------

# input = read("src/Dec16/input.txt", String);
# rules, myticket, tickets = split(input, "\n\n");
#
# part1(tickets, rules)
# part2(tickets, rules, myticket)
