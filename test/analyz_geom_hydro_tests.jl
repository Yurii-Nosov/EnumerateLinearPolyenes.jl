using EnumerateLinearPolyenes
using Test

@testset "Testset analyzlengthhydcc Isomers  ZE" begin
@test analyzlengthhydcc(genisoedge,6,1.44) == [0, 0]
@test analyzlengthhydcc(genisoedge,8,1.44) == [0, 0, 0] 
@test analyzlengthhydcc(genisoedge,10,1.44) == [0, 0, 0, 0, 0, 0]
@test analyzlengthhydcc(genisoedge,12,1.44) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 
end 

@testset "Testset analyzlengthhydcc ConTransIso  ZE" begin
@test analyzlengthhydcc(gentransconfedge,6,1.44) == [0, 0]
@test analyzlengthhydcc(gentransconfedge,8,1.44) == [0, 0, 0, 0, 0]
@test analyzlengthhydcc(gentransconfedge,10,1.44) == [0, 0, 0, 0, 0, 0, 0, 0, 0]
@test analyzlengthhydcc(gentransconfedge,12,1.44) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
end 

@testset "Testset analyzlengthhydcc ConOtherIso  ZE" begin
@test analyzlengthhydcc(genotherconfedge,6,1.44) == [0, 0]
@test analyzlengthhydcc(genotherconfedge,8,1.44) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
@test analyzlengthhydcc(genotherconfedge,10,1.44) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0]

end  


@testset "Testset analyzlengthch Isomers  ZE" begin
@test analyzlengthch(genisoedge,6,1.08) == [0, 0]
@test analyzlengthch(genisoedge,8,1.08) == [0, 0, 0] 
@test analyzlengthch(genisoedge,10,1.08) == [0, 0, 0, 0, 0, 0]
@test analyzlengthch(genisoedge,12,1.08) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0] 
end 

@testset "Testset analyzlengthch ConTransIso  ZE" begin
@test analyzlengthch(gentransconfedge,6,1.08) == [0, 0]
@test analyzlengthch(gentransconfedge,8,1.08) == [0, 0, 0, 0, 0]
@test analyzlengthch(gentransconfedge,10,1.08) == [0, 0, 0, 0, 0, 0, 0, 0, 0]
@test analyzlengthch(gentransconfedge,12,1.08) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
end 

@testset "Testset analyzlengthch ConOtherIso   ZE" begin
@test analyzlengthch(genotherconfedge,6,1.08) == [0, 0]
@test analyzlengthch(genotherconfedge,8,1.08) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
@test analyzlengthch(genotherconfedge,10,1.08) == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
 0, 0, 0, 0, 0]

end  