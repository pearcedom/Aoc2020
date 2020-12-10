using Aoc2020
using Test

println("Testing... 1, 2, 3, Testing...")

@testset "Dec01" begin
    x = [1721, 979, 366, 299, 675, 1456]
    @test Aoc2020.Dec01.part1(x) == 514579
    @test Aoc2020.Dec01.part2(x) == 241861950
end

@testset "Dec02" begin
    x = Aoc2020.Dec02.parse_input(
        ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]
    )
    @test Aoc2020.Dec02.part1(x) == 2
    @test Aoc2020.Dec02.part2(x) == 1
end
