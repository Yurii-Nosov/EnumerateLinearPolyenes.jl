
using EnumerateLinearPolyenes
using Test

@testset "Testset npov" begin
    @test npov(0) == 0
    @test npov(1) == 0
    @test npov(2) == 1
    @test npov(3) == 3
    @test npov(4) == 6
    @test npov(5) == 10
    @test npov(6) == 15
    @test npov(7) == 21
    @test npov(8) == 28
end 


@testset "Testset maxoverlappairs" begin
    @test maxoverlappairs(6,1) == 1
    @test maxoverlappairs(8,1) == 1
    @test maxoverlappairs(10,1) == 1
    @test maxoverlappairs(12,1) == 1
    @test maxoverlappairs(14,1) == 3
    @test maxoverlappairs(16,1) == 5
    @test maxoverlappairs(18,1) == 7
    @test maxoverlappairs(20,1) == 9
    @test maxoverlappairs(22,1) == 11
    @test maxoverlappairs(24,1) == 13
    @test maxoverlappairs(26,1) == 17
    @test maxoverlappairs(28,1) == 21
    @test maxoverlappairs(30,1) == 25
    @test maxoverlappairs(32,1) == 29
    @test maxoverlappairs(34,1) == 33
end 



@testset "Testset  calcdistrallgraphsoverlap" begin
    @test generatecoinoncis3p(10) |>  calcdistrallgraphsoverlap == [31, 0, 0]
    @test generatecoinoncis3p(12) |>  calcdistrallgraphsoverlap == [118, 0, 0, 0,0]
    @test generatecoinoncis3p(14) |>  calcdistrallgraphsoverlap == [422, 3, 2, 0, 0, 0,0]
    @test generatecoinoncis3p(16) |>  calcdistrallgraphsoverlap == [1456, 17, 17, 3, 2, 0, 0, 0,0]
    @test generatecoinoncis3p(18) |>  calcdistrallgraphsoverlap == [4938, 76, 95, 35, 11, 3, 2, 0, 0, 0,0]
    @test generatecoinoncis3p(20) |>  calcdistrallgraphsoverlap ==  [16546, 304, 487, 192, 79, 29, 11, 3, 
    2, 0, 0, 0,0]       
end 



