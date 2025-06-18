using Plots
using PlotThemes
using LegendrePolynomials

function LegendreVect(l::Int64)
    L=[x->Pl(x,n) for n in 1:l]
    return L
end

function SphericalHarmonicMatrix(l::Int64,m::Int64)
    SphHM=[(x,y)->Pl(cos(x),n)*exp(im*k*y) for n in 1:l for k in 1:m]
    return SphHM
end

M=SphericalHarmonicMatrix(2,2)
M[2,1](1.2,2)
Legendre=LegendreVect(7)
plot(Legendre,-1,1,title="Polinomios de Legendre")
