using Plots
import GLMakie as GLMk
using LegendrePolynomials

#Function that generates a vector of the first n Legendre Polynomials
function LegendreVect(l::Int64)
    L=[x->Pl(x,n) for n in 1:l]
    return L
end

#Function that generates a vectorized Matrix of Harmonics
function SphericalHarmonicMatrix(l::Int64,m::Int64)
    SphHM=[((x,y)->Pl(cos(x),n)*exp(im*k*y),n,k) for n in 0:l for k in 0:m]
    return SphHM
end

#individual Plots
function PlotSphericalHarmonic(l::Int64,m::Int64)
    Y(x,y)=Pl(cos(x),l)*exp(im*m*y)
    #Spherical Coordinates
    φs = range(0, 2π, length=361)   # angle within xy-plane relative to +x
    θs = range(0, π, length=181)    # angle relative to +z
    angles = [(φ,θ) for φ in φs, θ in θs]
    # Get radius (the Array Factor) at each angle
    rs = [real(Y(θ, φ)) for (φ,θ) in angles]   # radius = real/imag(Y(θ,φ))
    ρs = [imag(Y(θ, φ)) for (φ,θ) in angles]   # radius = real/imag(Y(θ,φ))
    # Convert this data to a 2D mesh
    real_spherical_mesh = [(r,φ,θ) for (r,(φ,θ)) in zip(rs,angles)]
    imag_spherical_mesh = [(r,φ,θ) for (r,(φ,θ)) in zip(ρs,angles)]

    # Convert spherical coordinates to rectangular coordinates
    xs = [r*sin(θ)*cos(φ) for (r,φ,θ) in real_spherical_mesh]
    ys = [r*sin(θ)*sin(φ) for (r,φ,θ) in real_spherical_mesh]
    zs = [r*cos(θ)        for (r,φ,θ) in real_spherical_mesh]

    as = [r*sin(θ)*cos(φ) for (r,φ,θ) in imag_spherical_mesh]
    bs = [r*sin(θ)*sin(φ) for (r,φ,θ) in imag_spherical_mesh]
    cs = [r*cos(θ)        for (r,φ,θ) in imag_spherical_mesh]
    # Plot
    fig = GLMk.Figure()
    axr = GLMk.Axis3(fig[1,1],title="Armonico esférico real Y($l,$m)")
    axi = GLMk.Axis3(fig[1,2],title="Armonico esférico imaginario Y($l,$m)")
    GLMk.surface!(axr, xs, ys, zs)
    GLMk.surface!(axi, as, bs, cs)
    GLMk.save("out/SphericalHarmonicsY($l,$m).png", fig)
end

PlotSphericalHarmonic(1,0)
PlotSphericalHarmonic(2,0)
PlotSphericalHarmonic(2,1)
PlotSphericalHarmonic(3,0)
PlotSphericalHarmonic(3,1)
PlotSphericalHarmonic(3,2)
PlotSphericalHarmonic(4,0)
PlotSphericalHarmonic(4,1)
PlotSphericalHarmonic(4,2)
PlotSphericalHarmonic(4,3)

Legendre=LegendreVect(7)
plot(Legendre,-1,1,title="Polinomios de Legendre")

## Now the code for the Spherical Harmonics

M=SphericalHarmonicMatrix(3,2)
# Coordinate space to be modeled
φs = range(0, 2π, length=361)   # angle within xy-plane relative to +x
θs = range(0, π, length=181)    # angle relative to +z
angles = [(φ,θ) for φ in φs, θ in θs]

fig = GLMk.Figure()
for i in 1:length(M)
    SphH(θ,ϕ) = real(M[i][1](θ,ϕ))
    # Get radius (the Array Factor) at each angle
    rs = [SphH(θ, φ) for (φ,θ) in angles]   # radius = AF(θ,φ)
    # Convert this data to a 2D mesh
    spherical_mesh = [(r,φ,θ) for (r,(φ,θ)) in zip(rs,angles)]

    # Convert spherical coordinates to rectangular coordinates
    xs = [r*sin(θ)*cos(φ) for (r,φ,θ) in spherical_mesh]
    ys = [r*sin(θ)*sin(φ) for (r,φ,θ) in spherical_mesh]
    zs = [r*cos(θ)        for (r,φ,θ) in spherical_mesh]

    # Plot
    ax = GLMk.Axis3(fig[M[i][2],M[i][3]],title="Armónico esférico Y($(M[i][2]),$(M[i][3]))")
    GLMk.surface!(ax, xs, ys, zs)
end
GLMk.save("out/SphericalHarmonics.png", fig)
#ANOTHER INDIVIDUAL PLOT
φs = range(0, 2π, length=361)   # angle within xy-plane relative to +x
θs = range(0, π, length=181)    # angle relative to +z
angles = [(φ,θ) for φ in φs, θ in θs]
# Get radius (the Array Factor) at each angle
Y(θ,φ)=M[5][1]
l=M[5][2]
m=M[5][3]
rs = [real(Y(θ, φ)) for (φ,θ) in angles]   # radius = real/imag(Y(θ,φ))
# Convert this data to a 2D mesh
spherical_mesh = [(r,φ,θ) for (r,(φ,θ)) in zip(rs,angles)]

# Convert spherical coordinates to rectangular coordinates
xs = [r*sin(θ)*cos(φ) for (r,φ,θ) in spherical_mesh]
ys = [r*sin(θ)*sin(φ) for (r,φ,θ) in spherical_mesh]
zs = [r*cos(θ)        for (r,φ,θ) in spherical_mesh]

# Plot
fig = GLMk.Figure()
axr = GLMk.Axis3(fig[1,1],title="Armonico esférico real Y($l,$m)")
GLMk.surface!(axr, xs, ys, zs)
#
