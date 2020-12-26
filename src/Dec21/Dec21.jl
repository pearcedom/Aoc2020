module Dec21

parse_input(x) = split.(replace.(x, r"[(),]" => ""), " contains ")

function make_ingredients(xs)
    ingredients = Dict()
    for x in xs
        ing = String.(split(x[1]))
        alg = Set(String.(split(x[2])))
        for i in ing
            ingredients[i] = haskey(ingredients, i) ? ingredients[i] ∪ alg : alg
        end
    end
    ingredients
end

function make_allergens(xs)
    allergens = Dict()
    for x in xs
        ing = Set(String.(split(x[1])))
        alg = String.(split(x[2]))
        for i in alg
            allergens[i] = haskey(allergens, i) ? allergens[i] ∩ ing : ing
        end
    end
    allergens
end

function part1(x)
    x = parse_input(x)
    ingredients = make_ingredients(x)
    allergens = make_allergens(x)
    out = setdiff(keys(ingredients), reduce(∪, values(allergens)))
    count(vcat([split(i[1]) for i in x]...) .∈ Ref(out))
end

function part2(x)
    x = parse_input(x)
    ingredients = make_ingredients(x)
    allergens = make_allergens(x)
    solved = []
    while any(length.(values(allergens)) .> 0)
        for (i, j) in allergens
            if length(j) == 1
                push!(solved, [j, i])
            end
        end
        for (i, j) in allergens
            for (k, _) in solved
                allergens[i] = setdiff(j, k)
            end
        end
    end
    unique!(solved)
    join([string(pop!(i)) for (i, _) in sort(solved, by = x->x[2])], ",")
end

end

#-----------------------------

#input = readlines("src/Dec21/input.txt")
#part1(input)
#part2(input)
