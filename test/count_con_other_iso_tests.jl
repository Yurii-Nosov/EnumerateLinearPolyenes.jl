using EnumerateLinearPolyenes
using Test

@testset "Testset countcoi" begin
    @test countcoi(6) == (6, 1, 1, 2, 0, 2)
    @test countcoi(8) == (8, 7, 3, 10, 2, 12)
    @test countcoi(10) == (10, 31, 15, 46, 11, 57)
    @test countcoi(12) == (12, 118, 67, 185, 58, 243)
    @test countcoi(14) == (14, 427, 289, 716, 285, 1001)
    @test countcoi(16) == (16, 1495, 1216, 2711, 1342, 4053)
    @test countcoi(18) == (18, 5160, 5014, 10174, 6131, 16305)
    @test countcoi(20) == (20, 17653, 20338, 37991, 27394, 65385)
    @test countcoi(22) == (22, 60120, 81416, 141536, 120321, 261857)       
end

