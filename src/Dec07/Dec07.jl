module Dec07

function parse_entries(x)
    entries = parse_entry.(x)
    Dict(i => j for (i, j) in entries)
end

function parse_entry(x)
    d = Dict()
    println(x)
    key, val = split(x, " contain ")
    key = replace(key, "bags" => "bag")
    val = replace(val, "." => "")
    val = replace(val, "bags" => "bag")
    if val == "no other bag"
        vals = []
    else
        vals = [v[3:end] for v in split(val, ", ") for i in 1:parse(Int, v[1])]
    end
    key, vals
end

function invert_dict(rules)
    d = Dict(i => [] for (i, j) in rules)
    for rule in rules
        for i in rule[2]
            d[i] = unique(vcat(d[i], (rule[1])))
        end
    end
    d
end

function find_parents(x, bags = [])
    bags = [bags..., x]
    if isempty(held_by[x])
        return bags
    else
        reduce(union, find_parents.(held_by[x], Ref(bags)))
    end
end

# We could definitely keep track of already traversed parent->child
# relationships and speed things up here but...
function find_children(x)
    bags = []
    function recurse_children(x)
        append!(bags, [x])
        if isempty(holds[x])
            return x
        else
            recurse_children.(holds[x])
        end
    end
    recurse_children(x)
    bags
end

part1(x) = length(find_parents(x)) - 1
part2(x) = length(find_children(x)) - 1

end

# input = readlines("src/Dec07/input.txt")
# const holds = parse_entries(input)
# const held_by = invert_dict(holds)
#
# using BenchmarkTools
# @btime part1("shiny gold bag")
# @btime part2("shiny gold bag")
