using Makie, MakieLayout

# Load DAMM function
include("DAMM.jl")

# Load parameters
include("DAMM_param.jl") 

x = Tsoil_range = 10.0:0.5:35.0
y = Msoil_range = 0.0:0.01:0.38

scene, layout = layoutscene(20, 20, 30, resolution = (700, 500))

sl_1 = layout[2, 1:5] = LSlider(scene, range= 1e-8:1e-8:1e-6)
Text_date = layout[1,1:5] = LText(scene, text= lift(X->string("kMSx", " = ", round(X, sigdigits = 2)), sl_1.value), textsize=15)
sl_2 = layout[4, 1:5] = LSlider(scene, range= 5e7:1e6:5e8)
Text_date = layout[3,1:5] = LText(scene, text= lift(X->string("AlphaSx", " = ", X), sl_2.value), textsize=15)
sl_3 = layout[6, 1:5] = LSlider(scene, range= 1e-4:1e-5:1e-2)
Text_date = layout[5,1:5] = LText(scene, text= lift(X->string("kMO2", " = ", X), sl_3.value), textsize=15)
sl_4 = layout[8, 1:5] = LSlider(scene, range= 58.0:0.2:70.0)
Text_date = layout[7,1:5] = LText(scene, text= lift(X->string("EaSx", " = ", X), sl_4.value), textsize=15)

ax3D = layout[1:15, 6:20] = LRect(scene, visible = false);
scene3D = Scene(scene, lift(IRect2D, ax3D.layoutnodes.computedbbox), camera = cam3d!, raw = false, show_axis = true);
surface!(scene3D, x, y, lift((kMSx_v, AlphaSx_v, kMO2_v, EaSx_v)->Float64[DAMM(Tsoil, Msoil; kMSx = kMSx_v, AlphaSx = AlphaSx_v, kMO2 = kMO2_v, EaSx = EaSx_v) for Tsoil in Tsoil_range, Msoil in Msoil_range], sl_1.value, sl_2.value, sl_3.value, sl_4.value), colormap = :lighttest, transparency = true, alpha = 0.1, shading = false, limits = Rect(10, 0, 0, 25, 0.4, 20))
wireframe!(scene3D, x, y, lift((kMSx_v, AlphaSx_v, kMO2_v, EaSx_v)->Float64[DAMM(Tsoil, Msoil; kMSx = kMSx_v, AlphaSx = AlphaSx_v, kMO2 = kMO2_v, EaSx = EaSx_v) for Tsoil in Tsoil_range, Msoil in Msoil_range], sl_1.value, sl_2.value, sl_3.value, sl_4.value), overdraw = true, transparency = true, color = (:black, 0.05))
scale!(scene3D, 1, 40, 1) 
center!(scene3D)

axis3D = scene3D[Axis]
axis3D[:ticks][:textsize] = (400.0,400.0,400.0)
axis3D.names.axisnames = ("Tsoil", "SWC", "Rsoil")
axis3D[:names][:textsize] = (400.0,400.0,400.0) # same as axis.names.textsize

scene

# to record some interaction
# record(scene, "test.gif") do io
#      for i = 1:200
#          sleep(0.1)     
#          recordframe!(io) # record a new frame
#      end
#  end
