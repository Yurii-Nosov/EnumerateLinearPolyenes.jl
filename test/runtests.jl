using EnumerateLinearPolyenes
using Test

@testset "Package Tests" begin

    @testset "BaseDet Tests" begin
        include("detaills_tests.jl")

    # Write your tests here.
    end

    @testset "countBasicIsoConf Tests" begin
        include("count_basic_iso_conf_tests.jl")

    # Write your tests here.
    end

    @testset "GenCodeFromZE Tests" begin
        include("gen_from_ze_tests.jl")

    # Write your tests here.
    end

    @testset "GenCodeFromBcd Tests" begin
        include("gen_from_bcd_tests.jl")

    # Write your tests here.
    end

    @testset "Calcul Class Sym" begin
        include("calc_class_sym_tests.jl")

    # Write your tests here.
    end

    @testset "Count Conf Other Isomers" begin
        include("count_con_other_iso_tests.jl")

    end

@testset "Calc Distrib Overlapping" begin
        include("calc_distr_overlap_tests.jl")

    end

    @testset "Control Geometry" begin
        include("analyz_geometry_tests.jl")
        include("analyz_geom_hydro_tests.jl")

    end

    @testset "Control Geometry Main" begin
        include("analyz_geom_main_tests.jl")
        
    end
end

