function FluidResistor(; name, R = 1.0)
    # 2 pin component
    @named oneport = OnePort()
    @unpack p, q = oneport
    ps = @parameters R=R
    eqs = [
        p ~ q * R
    ]
    extend(ODESystem(eqs, t, [], ps; name), oneport)
end

function VesselCompliance(; name, C = 1.0)
    @named oneport = OnePort()
    @unpack p, q = oneport
    ps = @parameters C=C
    D = Differential(t)
    eqs = [
        D(p) ~ q / C
    ]
    extend(ODESystem(eqs, t, [], ps; name), oneport)
end

function FluidInertia(; name, I = 1.0)
    @named oneport = OnePort()
    @unpack p, q = oneport
    ps = @parameters I=I
    D = Differential(t)
    eqs = [
        D(q) ~ p / I
    ]
    extend(ODESystem(eqs, t, [], ps; name), oneport)
end