using Makie, MakieLayout

# Load DAMM function
include("DAMM.jl")

# Load parameters
include("DAMM_param.jl") 

x = Tsoil_range = 10.0:0.5:35.0
y = Msoil_range = 0.0:0.01:0.38

scene, layout = layoutscene(20, 20, 30, resolution = (500, 500))

sl = layout[1, 1:20] = LSlider(scene, range= 1e-8:1e-9:1e-6)

ax3D = layout[2:20, 1:20] = LRect(scene, visible = false);
scene3D = Scene(scene, lift(IRect2D, ax3D.layoutnodes.computedbbox), camera = cam3d!, raw = false, show_axis = true);
surface!(scene3D, x, y, lift(kMSx->Float64[DAMM(Tsoil, Msoil, kMSx) for Tsoil in Tsoil_range, Msoil in Msoil_range], sl.value), colormap = :lighttest, transparency = true, alpha = 0.1, shading = false)
wireframe!(scene3D, x, y, lift(kMSx->Float64[DAMM(Tsoil, Msoil, kMSx) for Tsoil in Tsoil_range, Msoil in Msoil_range], sl.value), overdraw = true, transparency = true, color = (:black, 0.05))
scale!(scene3D, 5, 200, 5) 
center!(scene3D)

axis3D = scene3D[Axis]
axis3D[:ticks][:textsize] = (2000.0,2000.0,2000.0)
# axis3D.names.axisnames = ("Tsoil (°C)", "Msoil (m3 m-3)","Rsoil (umol m-2 s-1)")
# axis3D[:names][:textsize] = (2000.0,2000.0,2000.0) # same as axis.names.textsize

scene
