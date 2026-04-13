using EnumerateLinearPolyenes
using Test

@testset "Testset countcodefromze" begin
    @test countcodefromze(6) == (6, 2, 2, 2, 6)
    @test countcodefromze(8) == (8, 3, 5, 12, 20)
    @test countcodefromze(10) == (10, 6, 9, 57, 72)
    @test countcodefromze(12) == (12, 10, 19, 243, 272)
    @test countcodefromze(14) == (14, 20, 35, 1001, 1056)
    @test countcodefromze(16) == (16, 36, 71, 4053, 4160)
    @test countcodefromze(18) == (18, 72, 135, 16305, 16512)
    @test countcodefromze(20) == (20, 136, 271, 65385, 65792)
    @test countcodefromze(22) == (22, 272, 527, 261857, 262656)
    @test countcodefromze(24) == (24, 528, 1055, 1048017, 1049600)
    @test countcodefromze(26) == (26, 1056, 2079, 4193217, 4196352)    
end 



@testset "Testset countcodefrombcd" begin
    @test countcodefrombcd(6) == (6, 2, 2, 2, 6)
    @test countcodefrombcd(8) == (8, 3, 5, 12, 20)
    @test countcodefrombcd(10) == (10, 6, 9, 57, 72)
    @test countcodefrombcd(12) == (12, 10, 19, 243, 272)
    @test countcodefrombcd(14) == (14, 20, 35, 1001, 1056)
    @test countcodefrombcd(16) == (16, 36, 71, 4053, 4160)
    @test countcodefrombcd(18) == (18, 72, 135, 16305, 16512)
    @test countcodefrombcd(20) == (20, 136, 271, 65385, 65792)
    @test countcodefrombcd(22) == (22, 272, 527, 261857, 262656)
    @test countcodefrombcd(24) == (24, 528, 1055, 1048017, 1049600)
    @test countcodefrombcd(26) == (26, 1056, 2079, 4193217, 4196352 ) 
end 