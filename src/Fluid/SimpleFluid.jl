module SimpleFluid
using HoJMTK

@parameters t
const D = Differential(t)

include("core.jl")
include("sources.jl")
include("components.jl")


export Ground,
    connect_series,
    connect_parallel,
    connect_star,
    Pump,
    FluidResistor,
    VesselCompliance,
    FluidInertia,
    FluidGround
end 