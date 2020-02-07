using Makie, MakieLayout

# Load DAMM function
include("DAMM.jl")

# Load parameters
include("DAMM_param.jl") 

x = Tsoil_range = 10.0:0.5:35.0
y = Msoil_range = 0.0:0.01:0.38

scene, layout = layoutscene(20, 20, 30, resolution = (1000, 500))

Text_date = layout[1,1:5] = LText(scene, text= "kMSx", textsize=20)
sl_1 = layout[2, 1:5] = LSlider(scene, range= 1e-8:1e-9:1e-6)
Text_date = layout[3,1:5] = LText(scene, text= "AlphaSx", textsize=20)
sl_2 = layout[4, 1:5] = LSlider(scene, range= 5e7:1e6:5e8)
Text_date = layout[5,1:5] = LText(scene, text= "kMO2", textsize=20)
sl_3 = layout[6, 1:5] = LSlider(scene, range= 1e-4:1e-5:1e-2)

ax3D = layout[1:20, 7:20] = LRect(scene, visible = false);
scene3D = Scene(scene, lift(IRect2D, ax3D.layoutnodes.computedbbox), camera = cam3d!, raw = false, show_axis = true);
surface!(scene3D, x, y, lift((kMSx, AlphaSx, kMO2)->Float64[DAMM(Tsoil, Msoil, kMSx, AlphaSx, kMO2) for Tsoil in Tsoil_range, Msoil in Msoil_range], sl_1.value, sl_2.value, sl_3.value), colormap = :lighttest, transparency = true, alpha = 0.1, shading = false, limits = Rect(10, 0, 0, 25, 0.4, 20))
wireframe!(scene3D, x, y, lift((kMSx, AlphaSx, kMO2)->Float64[DAMM(Tsoil, Msoil, kMSx, AlphaSx, kMO2) for Tsoil in Tsoil_range, Msoil in Msoil_range], sl_1.value, sl_2.value, sl_3.value), overdraw = true, transparency = true, color = (:black, 0.05))
scale!(scene3D, 5, 200, 5) 
center!(scene3D)

axis3D = scene3D[Axis]
axis3D[:ticks][:textsize] = (2000.0,2000.0,2000.0)
# axis3D.names.axisnames = ("Tsoil (�C)", "Msoil (m3 m-3)","Rsoil (umol m-2 s-1)")
# axis3D[:names][:textsize] = (2000.0,2000.0,2000.0) # same as axis.names.textsize

scene


