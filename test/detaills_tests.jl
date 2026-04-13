using EnumerateLinearPolyenes
using Test

@testset "Testset zam" begin
    @test zam(1) == 0
    @test zam(0) == 1
end

@testset "Testset invert" begin
    @test invert([0,0,0,0,0]) == [1,1,1,1,1]
    @test invert([1,1,1,1,1]) == [0,0,0,0,0]
    @test invert([0,1,0,1,0]) == [1,0,1,0,1]
end

@testset "Testset func" begin
    @test func(0,0) == 1
    @test func(1,1) == 1
    @test func(0,1) == 0
    @test func(1,0) == 0
end

@testset "Testset checkminze - 2" begin
    @test checkminze([0,0,0,0,0]) == true
    @test checkminze([1,1,1,1,1]) == true
    @test checkminze([0,0,1,0,0]) == true
    @test checkminze([1,1,0,1,1]) == true
    @test checkminze([0,1,0,1,0]) == true
    @test checkminze([1,1,0,1,0]) == false
    @test checkminze([1,1,1,1,0]) == false
    @test checkminze([0,1,0,1,1]) == true 
    @test checkminze([0,1,1,1,1]) == true
end

@testset "Testset minze - 2" begin
    @test minze([0,0,0,0,0]) == [0,0,0,0,0]
    @test minze([1,1,1,1,1]) == [1,1,1,1,1]
    @test minze([0,0,1,0,0]) == [0,0,1,0,0]
    @test minze([1,1,0,1,1]) == [1,1,0,1,1]
    @test minze([0,1,0,1,0]) == [0,1,0,1,0]
    @test minze([1,1,0,1,0]) == [0,1,0,1,1]
    @test minze([1,1,1,1,0]) == [0,1,1,1,1]
end

@testset "Testset minbcd - 1" begin
    @test minbcd([0,0,0,0,0,0]) == [0,0,0,0,0,0]
    @test minbcd([0,1,1,1,1,1]) == [0,0,0,0,0,1]
    @test minbcd([0,0,1,0,0,0]) == [0,0,0,1,0,0]
    @test minbcd([0,1,0,1,1,1]) == [0,0,0,1,0,1]
    @test minbcd([0,1,0,1,0,1]) == [0,1,0,1,0,1]
    @test minbcd([0,1,0,1,0,0]) == [0,0,1,0,1,0]
    @test minbcd([0,1,1,1,0,1]) == [0,1,0,0,0,1]
end



@testset "Testset graphtypefromcode - 2" begin
    @test graphtypefromze([0, 0, 0, 0, 0])== 1
    @test graphtypefromze([0, 1, 0, 1, 0])== 1
    @test graphtypefromze([1, 0, 0, 0, 1]) == 2
    @test graphtypefromze([1, 0, 1, 0, 1]) == 2
    @test graphtypefromze([0, 0, 1, 0, 0]) == 2
    @test graphtypefromze([1, 1, 1, 1, 1]) == 3
    @test graphtypefromze([1, 1, 0, 1, 1]) == 3
     @test graphtypefromze([0, 1, 1, 1, 0]) == 3
end


@testset "Testset graphtypefromcode" begin
    @test graphtypefrombcd([0, 1, 0, 1, 0, 1])== 1
    @test graphtypefrombcd([0, 1, 1, 0, 0, 1])== 1
    @test graphtypefrombcd([0, 0, 1, 0, 1, 1]) == 2
    @test graphtypefrombcd([0, 0, 1, 1, 0, 0]) == 2
    @test graphtypefrombcd([0, 1, 0, 0, 1, 0]) == 2
    @test graphtypefrombcd([0, 0, 0, 0, 0, 0]) == 3
    @test graphtypefrombcd([0, 0, 0, 1, 1, 1]) == 3
    @test graphtypefrombcd([0, 1, 1, 1, 1, 0]) == 3
end