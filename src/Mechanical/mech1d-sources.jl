function ConstantVelocity(; name, v = 1.0)
    @named oneport = OnePort()
    @unpack u = oneport
    ps = @parameters x=x # TODO: does this cause naming issue?
    eqs = [
        v ~ u
    ]
    extend(ODESystem(eqs, t, [], ps; name), oneport)
end

function Force(; name, F = 1.0)
    @named oneport = OnePort()
    @unpack u, f = oneport
    ps = @parameters F=F
    eqs = [
        F ~ f
    ]
    extend(ODESystem(eqs, t, [], ps; name), oneport)
end
