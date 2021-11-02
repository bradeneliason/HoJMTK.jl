function Damper(; name, b = 1.0)
    # 2 pin component
    @named oneport = OnePort()
    @unpack u, f = oneport
    ps = @parameters b=b
    eqs = [
        u ~ f / b
    ]
    extend(ODESystem(eqs, t, [], ps; name), oneport)
end

function Mass(; name, m = 1.0)
    @named oneport = OnePort()
    @unpack u, f = oneport
    ps = @parameters m=m
    D = Differential(t)
    eqs = [
        D(u) ~ f / m
    ]
    extend(ODESystem(eqs, t, [], ps; name), oneport)
end

function Spring(; name, k = 1.0)
    @named oneport = OnePort()
    @unpack u, f = oneport
    ps = @parameters k=k
    D = Differential(t)
    eqs = [
        D(f) ~ k * u
    ]
    extend(ODESystem(eqs, t, [], ps; name), oneport)
end
