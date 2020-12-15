input = readlines("src/Dec14/example.txt")

mask = input[1]
mask = replace(mask, "mask = " => "")
mask = replace(mask, "X" => 0)
mask = parse(Int, mask, base = 2)


digits(mask, base = 2, pad = 36)

program = input[2:end]
program = replace.(program, "mem[" => "")
program = replace.(program, "]" => "")
program = split.(program, " = ")
