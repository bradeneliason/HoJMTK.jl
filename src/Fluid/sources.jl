function Pump(; name, P = 1.0)
    @named oneport = OnePort()
    @unpack p = oneport
    ps = @parameters P=P
    eqs = [
        P ~ p
    ]
    extend(ODESystem(eqs, t, [], ps; name), oneport)
end