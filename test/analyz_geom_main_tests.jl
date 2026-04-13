using EnumerateLinearPolyenes
using Test

@testset "Testset analyz Geometry Main" begin
    @test fromvcodetolistangles([0, 1, 0, 1],1) |> fromlistanglestovcode == 
    [0, 1, 0, 1]
    @test fromvcodetolistangles([0, 1, 1, 0],1) |> fromlistanglestovcode == 
    [0, 1, 1, 0]
    @test fromvcodetolistangles([0, 1, 0, 1, 0, 1],1) |> fromlistanglestovcode == 
    [0, 1, 0, 1, 0, 1]
    @test fromvcodetolistangles( [0, 1, 0, 1, 1, 0],1) |> fromlistanglestovcode ==  
    [0, 1, 0, 1, 1, 0]
    @test fromvcodetolistangles([0, 1, 1, 0, 0, 1],1) |> fromlistanglestovcode == 
    [0, 1, 1, 0, 0, 1]
    @test fromvcodetolistangles([0, 1, 0, 1, 0, 1, 0, 1],1) |> fromlistanglestovcode == 
    [0, 1, 0, 1, 0, 1, 0, 1]

end    

@testset "Testset analyz Geometry Main Hyd" begin
    @test fromvcodetolistangles([0, 0, 1, 1],2) |> fromlistanglestovcode == 
    [0, 0, 1, 1]
    @test fromvcodetolistangles([0, 1, 0, 0],2) |> fromlistanglestovcode ==
     [0, 1, 0, 0]
    @test fromvcodetolistangles([0, 0, 1, 0, 1, 1],2) |> fromlistanglestovcode == 
    [0, 0, 1, 0, 1, 1]
    @test fromvcodetolistangles([0, 0, 1, 1, 0, 0],2) |> fromlistanglestovcode ==
     [0, 0, 1, 1, 0, 0]
    @test fromvcodetolistangles([0, 1, 0, 0, 1, 0],2) |> fromlistanglestovcode ==
     [0, 1, 0, 0, 1, 0]
    @test fromvcodetolistangles([0, 1, 0, 0, 1, 1],2) |> fromlistanglestovcode ==
     [0, 1, 0, 0, 1, 1]

end    



