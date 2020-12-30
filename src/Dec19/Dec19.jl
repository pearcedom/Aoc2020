module Dec19

struct Seq
    x::Array
end

struct Branch
    x::Array
end

follow_rules(x::Char, rules::Dict) = x
function follow_rules(x::String, rules::Dict)
    follow_rules(rules[x], rules)
end
function follow_rules(x::Branch, rules::Dict)
    res = vcat(follow_rules.(x.x, Ref(rules))...)
    #println(res)
    res
end
function follow_rules(x::Seq, rules::Dict)
    res = simplify(follow_rules.(x.x, Ref(rules)))
    #println(res)
    res
end


out = follow_rules(Seq(["42"]), rules)
x = [out, out, out, out, out, out]
combine(x);

x = [["A", "B", "C", "X"], ["D", "E", "F", "X"], ["G", "H", "I", "X"]]
x = vcat(x, x, x, x)
@time combine(x);
res = [repeat(i, Int(length(x) / 3)) for i in ["XEI", "BEG"]]
@time combine2(x, res)


function combine(x, s = "")
    if isempty(x)
        return s
    end
    y = x[1]
    vcat([combine(x[2:end], s*i) for i in y]...)
end

function combine2(x, res, s = "")
    if isempty(x)
        return s
    elseif all(s .!= [i[1:length(s)] for i in res])
        return
    else
        y = x[1]
        vcat([combine(x[2:end], res, s*i) for i in y]...)
    end
end


simplify(x::Char) = x
simplify(x::Array{Char, 1}) = reduce(*, x)
function simplify(x::Array{Array{String, 1}, 1})
    length(x) == 1 ? x[1] : combine(x)
end
function simplify(x::Array{Any, 1})
    #all(length.(x) .> maximum(length.(messages))) ? "" : collate(x)
    collate(x)
end

function collate(r::String, vs::Array)
    [[i *= r for i in v] for v in vs]
end
function collate(r::Char, vs::Array)
    collate(string(r), vs)
end
function collate(r::Array, vs::Array)
    vcat([[[i *= s for i in v] for s in r] for v in vs]...)
end
function collate(rs::Array)
    vs = [[""]]
    while !isempty(rs)
        r = popfirst!(rs)
        vs = collate(r, vs)
    end
    vcat(vs...)
end

function part1(x, y)
    followed = follow_rules("0", y)
    length([i for i in x if i in followed])
end

input = readlines("src/Dec19/example2.txt")
split_by = findfirst(x->x .== "", input)
messages = input[split_by+1:end]

rules = Dict{String,Any}()
for i in input[1:split_by-1]
    colon_at = findfirst(':', i)
    key = string(i[1:colon_at-1])
    rule = string.(split(i[colon_at+2:end], " "))
    if any(occursin.("\"", rule))
        rule = replace.(rule, "\"" => "")[1][1]
    elseif any(rule .== "|")
        pipe_at = findfirst(x->x .== "|", rule)
        rule = Branch([Seq(rule[1:pipe_at-1]), Seq(rule[pipe_at+1:end])])
    else
        rule = Seq(rule)
    end
    rules[key] = rule
end

rules["8"] = Branch([
    Seq(["42"]),
    Seq(["42", "42"]),
    Seq(["42", "42", "42"]),
    #Seq(["42", "42", "42", "42"])
   ])

rules["11"] = Branch([
    Seq(["42", "31"]),
    Seq(["42", "42", "31", "31"]),
    #Seq(["42", "42", "42", "31", "31", "31"]),
    #Seq(["42", "42", "42", "42", "31", "31", "31", "31"])
   ])

@time part2(messages, rules)

