using EnumerateLinearPolyenes
using Test

@testset "Testset calcClassSym Isomers from ZE" begin
    @test symclassfromedge([0,0,0,0,0]) == 2
    @test symclassfromedge([0,0,0,1,0]) == 3
    @test symclassfromedge([0,1,0,1,0]) == 2
    @test symclassfromedge([0,0,0,0,0,0,0]) == 2
    @test symclassfromedge([0,0,0,0,0,1,0]) == 3
    @test symclassfromedge([0,0,0,1,0,1,0]) == 3
    @test symclassfromedge([0,0,0,1,0,0,0]) == 1
    @test symclassfromedge([0,1,0,1,0,1,0]) == 1
    @test symclassfromedge([0,1,0,0,0,1,0]) == 2
    @test symclassfromedge([0,0,0,1,0,0,0]) == 1
    @test symclassfromedge([0,0,1,0,0,0,0]) == 3
    @test symclassfromedge([1,0,0,0,1,0,0]) == 3
end 




@testset "Testset calcClassSym Conf Trans Isomers from ZE" begin
    @test symclassfromedge([1,0,0,0,1]) == 2
    @test symclassfromedge([1,0,1,0,1]) == 1
    @test symclassfromedge([0,0,1,0,0]) == 1
    @test symclassfromedge([0,0,1,0,1]) == 3
    @test symclassfromedge([0,0,0,0,1]) == 3
    @test symclassfromedge([1,0,0,0,0,0,1]) == 2
    @test symclassfromedge([1,0,0,0,0,1,0]) == 3
    @test symclassfromedge([1,0,1,0,1,0,1]) == 2
    @test symclassfromedge([0,0,1,0,0,0,1]) == 3
    @test symclassfromedge([0,0,1,0,1,0,1]) == 3
    @test symclassfromedge([0,0,1,0,1,0,0]) == 2
    @test symclassfromedge([0,0,0,0,1,0,0]) == 3
    @test symclassfromedge([0,0,0,0,1,0,1]) == 3
    @test symclassfromedge([0,0,0,0,0,0,1]) == 3
end  


@testset "Testset calcClassSym Isomers from BCD" begin
    @test symclassfromvertex([0, 1, 0, 1, 0, 1]) == 2
    @test symclassfromvertex([0, 1, 0, 1, 1, 0]) == 3
    @test symclassfromvertex([0, 1, 1, 0, 0, 1]) == 2
    @test symclassfromvertex([0, 1, 0, 1, 0, 1, 0, 1]) == 2
    @test symclassfromvertex([0, 1, 0, 1, 0, 1, 1, 0]) == 3
    @test symclassfromvertex([0, 1, 0, 1, 1, 0, 0, 1]) == 3
    @test symclassfromvertex([0, 1, 0, 1, 1, 0, 1, 0]) == 1
    @test symclassfromvertex([0, 1, 1, 0, 0, 1, 1, 0]) == 1
    @test symclassfromvertex([0, 1, 1, 0, 1, 0, 0, 1]) == 2    
end


@testset "Testset calcClassSym Conf Trans Isomers from BCD" begin
    @test symclassfromvertex([0, 0, 1, 0, 1, 1]) == 2
    @test symclassfromvertex([0, 0, 1, 1, 0, 0]) == 1
    @test symclassfromvertex([0, 1, 0, 0, 1, 0]) == 1
    @test symclassfromvertex([0, 1, 0, 0, 1, 1]) == 3
    @test symclassfromvertex([0, 1, 0, 1, 0, 0]) == 3
    @test symclassfromvertex([0, 0, 1, 0, 1, 0, 1, 1]) == 2
    @test symclassfromvertex([0, 0, 1, 0, 1, 1, 0, 0]) == 3    
    @test symclassfromvertex([0, 0, 1, 1, 0, 0, 1, 1]) == 2
    @test symclassfromvertex([0, 1, 0, 0, 1, 0, 1, 1]) == 3
    @test symclassfromvertex([0, 1, 0, 0, 1, 1, 0, 0]) == 3
    @test symclassfromvertex([0, 1, 0, 0, 1, 1, 0, 1]) == 2
    @test symclassfromvertex([0, 1, 0, 1, 0, 0, 1, 0]) == 3
    @test symclassfromvertex([0, 1, 0, 1, 0, 0, 1, 1]) == 3
    @test symclassfromvertex( [0, 1, 0, 1, 0, 1, 0, 0]) == 3
end  
