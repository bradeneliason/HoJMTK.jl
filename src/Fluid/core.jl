# a point in the circuit with a given voltage and current
@connector function Port(; name)
    sts = @variables p(t)=1.0 q(t)=1.0
    ODESystem(Equation[], t, sts, []; name)
end

# Fluid ground port, where pressure is 0
function FluidGround(; name)
    @named g = Port()
    eqs = [g.p ~ 0.]
    compose(ODESystem(eqs, t, [], []; name), g)
end

# abstraction for all 2-pin components
function OnePort(; name)
    # two pins
    @named i = Port() # Inlet
    @named o = Port() # Outlet
    # component has a pressure across it, and flow through
    sts = @variables p(t)=1.0 q(t)=1.0
    eqs = [
        p ~ i.p - o.p    # KVL TODO: rename
        0. ~ i.q + o.q   # Conservation of mass
        q ~ i.q          # Flow through component is Flow through +ve port
    ]
    compose(ODESystem(eqs, t, sts, []; name), i, o)
end

function ModelingToolkit.connect(::Type{Port}, ps...)
    eqs = [
        0. ~ sum(port->port.q, ps)    # KCL 
    ]
    # KVL
    for i in 1:length(ps)-1
        push!(eqs, ps[i].p ~ ps[i+1].p)
    end
    return eqs
end

connect_star(comps...) = connect([comp.n for comp in comps]...)

function connect_series(comps...)
    eqs = Equation[]
    for i in 1:length(comps)-1
        eqs = vcat(eqs, connect(comps[i].i, comps[i+1].o))
    end
    return eqs
end

function connect_parallel(comps...)
    return [
        connect((comp.i for comp in comps)...)
        connect((comp.o for comp in comps)...)
    ]
end