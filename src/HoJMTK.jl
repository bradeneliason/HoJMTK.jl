module HoJMTK

using Reexport
@reexport using ModelingToolkit
@reexport using DifferentialEquations

include("Electrical/Electrical.jl")
include("Fluid/SimpleFluid.jl")
include("Mechanical/Mechanical1D.jl")
end