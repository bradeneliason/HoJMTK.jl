using DifferentialEquations, ModelingToolkit
using HoJMTK.Mechanical1D

k = 1.0
m = 1.0
b = 1.0
v = 1.0
@named spring = Spring(k=k)
@named mass = Mass(m=m)
@named damper = Damper(b=b)
@named source = ConstantVelocity(v=v)
@named fixed = Fixed()

# mech1d_eqs = [
#           connect(source.p1, damper.p1)
#           connect(damper.p2, mass.p2)
#           connect(mass.p2, source.p2, fixed.g)
#          ]
mech1d_eqs = [
          connect(source.p1, mass.p1)
          connect(mass.p2, damper.p1, spring.p1)
          connect(damper.p2, spring.p2, fixed.g)
          connect(source.p2, fixed.g)
         ]

@variables t
@named _mech1d_model = ODESystem(mech1d_eqs, t)
@named mech1d_model = compose(_mech1d_model, [spring, mass, damper, source, fixed])
sys = structural_simplify(mech1d_model)
u0 = [
    mass.p1 => 0.0
     ]
prob = ODAEProblem(sys, u0, (0, 10.0))
sol = solve(prob, Tsit5())

using Plots
plot(sol)