using Makie

# Load DAMM function
include("DAMM.jl")

# Load parameters
include("DAMM_param.jl") 

Tsoil_range = 10.0:0.5:40.0
Msoil_range = 0.05:0.01:0.35

Rsoil_DAMM = Float64[DAMM(Tsoil, Msoil) for Tsoil in Tsoil_range, Msoil in Msoil_range]

scene = surface(Tsoil_range, Msoil_range, Rsoil_DAMM)





