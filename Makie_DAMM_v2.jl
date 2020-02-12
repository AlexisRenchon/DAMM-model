using Makie, MakieLayout

# Load DAMM function
include("DAMM.jl")

# Load parameters
include("DAMM_param.jl") 

x = Tsoil_range = 10.0:0.5:35.0
y = Msoil_range = 0.0:0.01:0.38

scene, layout = layoutscene()
texts = Array{LText}(undef,5)
sliderranges = [
    1e-8:1e-8:1e-6, 
    5e7:1e6:5e8,
    1e-4:1e-5:1e-2,
    58.0:0.2:70.0,
    0.005:0.001:0.02]
sliders = [LSlider(scene, range = sr) for sr in sliderranges]
texts[1] = LText(scene, text= lift(X->string("kMSx", " = ", round(X, sigdigits = 2)), sliders[1].value), textsize=15, width = Auto(false))
texts[2] = LText(scene, text= lift(X->string("AlphaSx", " = ", X), sliders[2].value), textsize=15, width = Auto(false))
texts[3] = LText(scene, text= lift(X->string("kMO2", " = ", X), sliders[3].value), textsize=15, width = Auto(false))
texts[4] = LText(scene, text= lift(X->string("EaSx", " = ", X), sliders[4].value), textsize=15, width = Auto(false))
texts[5] = LText(scene, text= lift(X->string("Sxtot", " = ", X, " g C cm-3"), sliders[5].value), textsize=15, width = Auto(false))
vertical_sublayout = layout[1, 1] = vbox!(
    Iterators.flatten(zip(texts, sliders))...;
    width = 400, height = Auto(false))

ax3D = layout[1, 2] = LRect(scene, visible = false);
scene3D = Scene(scene, lift(IRect2D, ax3D.layoutnodes.computedbbox), camera = cam3d!, raw = false, show_axis = true);
surface!(scene3D, x, y, lift((kMSx_v, AlphaSx_v, kMO2_v, EaSx_v, Sxtot_v)->Float64[DAMM(Tsoil, Msoil; kMSx = kMSx_v, AlphaSx = AlphaSx_v, kMO2 = kMO2_v, EaSx = EaSx_v, Sxtot = Sxtot_v) for Tsoil in Tsoil_range, Msoil in Msoil_range], sliders[1].value, sliders[2].value, sliders[3].value, sliders[4].value, sliders[5].value), colormap = :lighttest, transparency = true, alpha = 0.1, shading = false, limits = Rect(10, 0, 0, 25, 0.4, 20))
wireframe!(scene3D, x, y, lift((kMSx_v, AlphaSx_v, kMO2_v, EaSx_v, Sxtot_v)->Float64[DAMM(Tsoil, Msoil; kMSx = kMSx_v, AlphaSx = AlphaSx_v, kMO2 = kMO2_v, EaSx = EaSx_v, Sxtot = Sxtot_v) for Tsoil in Tsoil_range, Msoil in Msoil_range], sliders[1].value, sliders[2].value, sliders[3].value, sliders[4].value, sliders[5].value), overdraw = true, transparency = true, color = (:black, 0.05))
scale!(scene3D, 1, 40, 1) 
center!(scene3D)
axis3D = scene3D[Axis]
axis3D[:ticks][:textsize] = (400.0,400.0,400.0)
axis3D.names.axisnames = ("Tsoil", "SWC", "Rsoil")
axis3D[:names][:textsize] = (400.0,400.0,400.0) # same as axis.names.textsize

scene

