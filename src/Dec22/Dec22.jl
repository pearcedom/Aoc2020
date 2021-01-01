module Dec22

function parse_input(input)
    input = split(input, "\n\n")
    p1, p2 = [parse.(Int, split(i, "\n")[2:end]) for i in input]
    p1, p2
end

function combat!(p1, p2)
    while !isempty(p1) && !isempty(p2)
        c1 = popfirst!(p1)
        c2 = popfirst!(p2)
        c1 > c2 ? append!(p1, [c1, c2]) : append!(p2, [c2, c1])
    end
    score_game(p1, p2)
end

function recursive_combat!(p1, p2)
    previous = []
    while !isempty(p1) && !isempty(p2) && !((p1, p2) in previous)
        previous = push!(previous, deepcopy((p1, p2)))
        c1 = popfirst!(p1)
        c2 = popfirst!(p2)
        if length(p1) >= c1 && length(p2) >= c2
            p1_wins, _ = recursive_combat!(p1[1:c1], p2[1:c2])
        else
            p1_wins = c1 > c2
        end
        p1_wins ? append!(p1, [c1, c2]) : append!(p2, [c2, c1])
    end
    if isempty(p2)
        p1_wins = true
    elseif ((p1, p2) in previous)
        p1_wins =  true
    else
        p1_wins = false
    end
    p1_wins, score_game(p1, p2)
end

score_game(p1, p2) = sum(i*j for (i, j) in enumerate(reverse(vcat(p1, p2))))

part1(x) = combat!(parse_input(x)...)
part2(x) = recursive_combat!(parse_input(x)...)[2]

end

#-----------------------------

#input = readchomp("src/Dec22/input.txt")
#part1(input)
#part2(input)
