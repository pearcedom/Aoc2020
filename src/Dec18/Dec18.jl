module Dec18

function evaluate(expr::Array)
    res = 0
    while !isempty(expr)
        op, n = popfirst!(expr)
        res = eval(op)(res, evaluate(n))
    end
    res
end

evaluate(expr::Int) = expr

function oplist(x)
    x = deepcopy(x)
    pushfirst!(x, '+')
    expr = Any[]
    while !isempty(x)
        op = getfield(Main, Symbol(popfirst!(x)))
        n = popfirst!(x)
        if n == '('
            i = close_paren(x)
            n = oplist(x[1:i-1])
            x = x[i+1:end]
        else
            n = parse(Int, n)
        end
        push!(expr, [op, n])
    end
    expr
end

function close_paren(x, fwd = true)
    open = fwd ? '(' : ')'
    close = fwd ? ')' : '('
    counter = 1
    for (i, j) in enumerate(x)
        if j == open
            counter += 1
        elseif j == close
            counter += -1
        else
            continue
        end
        if counter == 0
            return i
        end
    end
end

function make_advanced(x)
    i = 1
    while i < length(x)
        if x[i] == '+'
            start = x[i-1] == ')' ? i - close_paren(reverse(x[1:i-2]), false) - 1 : i-1
            stop = x[i+1] == '(' ? i + close_paren(x[i+2:end]) + 1 : i+1
            x = vcat(x[1:start-1], '(', x[start:stop], ')', x[stop+1:end])
            i += 2
        else
            i += 1
        end
    end
    x
end

part1(x) = sum(evaluate(oplist(collect(replace(i, " " => "")))) for i in x)
part2(x) = sum(evaluate(oplist(make_advanced(collect(replace(i, " " => ""))))) for i in x)

end

#-----------------------------

# input = readlines("src/Dec18/input.txt")
# @time part1(input)
# @time part2(input)


