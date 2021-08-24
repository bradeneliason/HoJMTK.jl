using DifferentialEquations, ModelingToolkit
using HoJMTK.Electrical
using Plots

# Based on https://mtk.sciml.ai/dev/tutorials/acausal_components/
R = 1.0
C = 1.0
V = 1.0
@named resistor = Resistor(R=R)
@named capacitor = Capacitor(C=C)
@named source = DCVoltageSource(V=V)
@named ground = Ground()

rc_eqs = [
          connect(source.p, resistor.p)
          connect(resistor.n, capacitor.p)
          connect(capacitor.n, source.n, ground.g)
         ]

@variables t
@named _rc_model = ODESystem(rc_eqs, t)
@named rc_model = compose(_rc_model, [resistor, capacitor, source, ground])
sys = structural_simplify(rc_model)
u0 = [
      capacitor.v => 0.0
     ]
prob = ODAEProblem(sys, u0, (0, 10.0))
sol = solve(prob, Tsit5())

plot(sol)