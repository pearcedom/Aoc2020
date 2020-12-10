module Dec04

function is_valid(x)
    n = length(findall(":", x))
    if n == 8
        return true
    elseif n == 7
        !occursin("cid", x)
    else
        return false
    end
end

function input2dict(x)
    x = replace(x, "\n" => "")
    x = replace(x, " " => "")
    m = findall(r"[a-z]{3}:", x)
    m = vcat(m, length(x)+1)
    d = Dict()
    for i in 1:length(m)-1
        start = first(m[i])
        stop = first(m[i+1])-1
        el = x[start:stop]
        key, val = split(el, ":")
        d[key] = val
    end
    d
end

function is_really_valid(x)

    for i in ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        if !(i in keys(x))
            return false
        end
    end

    byr = tryparse(Int, x["byr"]) in 1920:2002
    iyr = tryparse(Int, x["iyr"]) in 2010:2020
    eyr = tryparse(Int, x["eyr"]) in 2020:2030
    if !all([byr, iyr, eyr])
        return false
    end

    pid = tryparse(Int, x["pid"])
    if isnothing(pid)
        return false
    elseif length(x["pid"]) != 9
        return false
    end

    m = match(r"([0-9]{2,3})([a-z]{2})", x["hgt"])
    if isnothing(m)
        return false
    else
        hgt, unit = m.captures
    end

    hgt = tryparse(Int, hgt)
    if unit == "cm" && !(hgt in 150:193)
        return false
    elseif unit == "in" && !(hgt in 59:76)
        return false
    end

    if x["hcl"][1] != '#'
        return false
    end
    if !all(occursin.(collect(x["hcl"][2:end]), "0123456789abcdef"))
        return false
    end

    if !(x["ecl"] in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
        return false
    end

    return true
end

part1(x) = count(is_valid.(x))
part2(x) = count(is_really_valid.(input2dict.(input)))

end

# input = split(read("src/Dec04/input.txt", String), "\n\n")
# part1(input)
# part2(input)
