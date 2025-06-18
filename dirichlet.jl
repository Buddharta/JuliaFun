using Plots
using PlotThemes

function DirichletVect(N::Int64)
    D=[x->sin((n+1/2)*x)/(2*sin(x/2)) for n in 1:N]
    return D
end

function FejerVect(N::Int64)
    F=[x->sin((n/2)*x)^2/(sin(x/2))^2 for n in 1:N]
    return F
end

Dirichlet = DirichletVect(7)
Fejer = FejerVect(7)
plot(Dirichlet,-π,π,title="Kernels de Dirichlet")
plot(Fejer,-π,π,title="Kernels de Fejér")
