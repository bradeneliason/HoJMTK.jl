# a point in the system with a given velocity and force
@connector function Port(; name)
    sts = @variables u(t)=1.0 f(t)=1.0
    ODESystem(Equation[], t, sts, []; name)
end

# Fixed pin, where velocity is 0
function Fixed(; name)
    @named g = Port()
    eqs = [g.u ~ 0.]
    compose(ODESystem(eqs, t, [], []; name), g)
end

# abstraction for all 2-port components
function OnePort(; name)
    # two ports
    @named p1 = Port()
    @named p2 = Port()
    sts = @variables u(t)=1.0 f(t)=1.0
    eqs = [
        u ~ p1.u - p2.u    # 
        0. ~ p1.f + p2.f   # 
        f ~ p1.f           # 
    ]
    compose(ODESystem(eqs, t, sts, []; name), p1, p2)
end

function ModelingToolkit.connect(::Type{Port}, ps...)
    eqs = [
        0. ~ sum(p->p.f, ps)
    ]

    for i in 1:length(ps)-1
        push!(eqs, ps[i].u ~ ps[i+1].u)
    end
    return eqs
end

connect_star(comps...) = connect([comp.n for comp in comps]...)
    
function connect_series(comps...)
    eqs = Equation[]
    for i in 1:length(comps)-1
        eqs = vcat(eqs, connect(comps[i].p1, comps[i+1].p2))
    end
    return eqs
end

function connect_parallel(comps...)
    return [
        connect((comp.p1 for comp in comps)...)
        connect((comp.p2 for comp in comps)...)
    ]
end
