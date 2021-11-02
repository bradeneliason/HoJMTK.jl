module Mechanical1D
using HoJMTK

@parameters t
const D = Differential(t)

include("mech1d-core.jl")
include("mech1d-sources.jl")
include("mech1d-components.jl")

export 
    Fixed,
    connect_series,
    connect_parallel,
    connect_star,
    ConstantVelocity,
    Force,
    Damper,
    Mass,
    Spring
end