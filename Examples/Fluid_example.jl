using DifferentialEquations, ModelingToolkit
using HoJMTK.SimpleFluid

R = 1.0
C = 1.0
P = 1.0
@named resistor = FluidResistor(R=R)
@named compliance = VesselCompliance(C=C)
@named source = Pump(P=P)
@named ground = FluidGround()

frc_eqs = [
          connect(source.i, resistor.i)
          connect(resistor.o, compliance.i)
          connect(compliance.o, source.o, ground.g)
         ]

@variables t
@named _frc_model = ODESystem(frc_eqs, t)
@named frc_model = compose(_frc_model, [resistor, compliance, source, ground])
sys = structural_simplify(frc_model)
u0 = [
        compliance.p => 0.0
     ]
prob = ODAEProblem(sys, u0, (0, 10.0))
sol = solve(prob, Tsit5())

using Plots
plot(sol)