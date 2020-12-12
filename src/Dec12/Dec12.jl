module Dec12

struct Ship
    x::Int
    y::Int
    dir::Char
    waypoint::Tuple
end
Ship(x::Int, y::Int, dir::Char) = Ship(x, y, dir, ())
Ship() = Ship(0, 0, 'E', (10, 1))

struct Instruction
    action::Char
    val::Int
end

@enum Dir N=0 E=90 S=180 W=270
function Dir(x::Char)
    d = Dict('N' => 0, 'E' => 90, 'S' => 180, 'W' => 270)
    Dir(d[x])
end

function move(s::Ship, instructions::Array, f::Function)
    for i in instructions
        s = move(s, i, f)
    end
    s
end

function move(s::Ship, i::Instruction, f::Function)
    (x, y), d, w = f(i, Dir(s.dir), s.waypoint)
    Ship(s.x + x, s.y + y, d, w)
end

function interpret(i::Instruction, d::Dir, w::Tuple)
    a = i.action
    c = (0, 0)
    if a == 'N'
        c = (0, i.val)
    elseif a == 'S'
        c = (0, -i.val)
    elseif a == 'E'
        c = (i.val, 0)
    elseif a == 'W'
        c = (-i.val, 0)
    elseif a == 'L'
        d = (Int(d) - i.val) % 360
        d = d < 0 ? 360 + d : d
        d = Dir(d)
    elseif a == 'R'
        d = Dir((Int(d) + i.val) % 360)
    elseif a == 'F'
        return interpret(Instruction(first(string(d)), i.val), d, w)
    end
    (c, first(string(d)), w)
end

function interpret2(i::Instruction, d::Dir, w::Tuple)
    a = i.action
    c = (0, 0)
    if a == 'N'
        w = w .+ (0, i.val)
    elseif a == 'S'
        w = w .+ (0, -i.val)
    elseif a == 'E'
        w = w .+ (i.val, 0)
    elseif a == 'W'
        w = w .+ (-i.val, 0)
    elseif a == 'L'
        x2 = w[1] * cos(deg2rad(i.val)) - (w[2] * sin(deg2rad(i.val)))
        y2 = w[2] * cos(deg2rad(i.val)) + (w[1] * sin(deg2rad(i.val)))
        w = (Int(round(x2)), Int(round(y2)))
    elseif a == 'R'
        x2 = w[1] * cos(deg2rad(-i.val)) - (w[2] * sin(deg2rad(-i.val)))
        y2 = w[2] * cos(deg2rad(-i.val)) + (w[1] * sin(deg2rad(-i.val)))
        w = (Int(round(x2)), Int(round(y2)))
    elseif a == 'F'
        c = w .* i.val
    end
    (c, first(string(d)), w)
end

manhattan_distance(x, y) = abs(x) + abs(y)
manhattan_distance(x::Ship) = manhattan_distance(x.x, x.y)

part1(x) = manhattan_distance(move(Ship(), x, interpret))
part2(x) = manhattan_distance(move(Ship(), x, interpret2))

end

#-----------------------------

# input = [Instruction(i[1], parse(Int, i[2:end])) for i in eachline("src/Dec12/input.txt")]
# @time part1(input)
# @time part2(input)
