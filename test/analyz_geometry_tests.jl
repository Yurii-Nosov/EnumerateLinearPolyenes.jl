using EnumerateLinearPolyenes
using Test


@testset "Testset analyzlengthcc Isomers  ZE" begin
@test analyzlengthcc(genisoedge,6,1.44) == [0, 0]
@test analyzlengthcc(genisoedge,8,1.44) == [0, 0, 0] 
@test analyzlengthcc(genisoedge,10,1.44) == [0, 0, 0, 0, 0, 0]
 @test analyzlengthcc(genisoedge,12,1.44) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 
end 

@testset "Testset analyzlengthcc ConTransIso  ZE" begin
@test analyzlengthcc(gentransconfedge,6,1.44) == [0, 0]
@test analyzlengthcc(gentransconfedge,8,1.44) == [0, 0, 0, 0, 0]
@test analyzlengthcc(gentransconfedge,10,1.44) == [0, 0, 0, 0, 0, 0, 0, 0, 0]
@test analyzlengthcc(gentransconfedge,12,1.44) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
end 

@testset "Testset analyzlengthcc ConOtherIso  ZE" begin
@test analyzlengthcc(genotherconfedge,6,1.44) == [0, 0]
@test analyzlengthcc(genotherconfedge,8,1.44) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
@test analyzlengthcc(genotherconfedge,10,1.44) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
 0, 0, 0, 0, 0]
end 


