using Makie

# Load DAMM function
include("DAMM.jl")

# Load parameters
include("DAMM_param.jl") 

x = Tsoil_range = 10.0:0.5:35.0
y = Msoil_range = 0.0:0.01:0.38

z = Rsoil_DAMM = Float64[DAMM(Tsoil, Msoil) for Tsoil in Tsoil_range, Msoil in Msoil_range]

scene = surface(x, y, z, colormap = :lighttest, transparency = true, alpha = 0.1, shading = false)
wireframe!(scene, x, y, z, overdraw = true, transparency = true, color = (:black, 0.05))
scale!(scene, 5, 200, 5) # Currently needed to rescale Msoil, because its range (00.5 - 0.35) is smaller than Tsoil and Rsoil range
center!(scene)

axis3D = scene[Axis]
axis3D[:ticks][:textsize] = (2000.0,2000.0,2000.0)

