using Makie, Observables

# Load DAMM function
include("DAMM.jl")

# Load parameters
include("DAMM_param.jl") 

x = Tsoil_range = 10.0:0.5:35.0
y = Msoil_range = 0.0:0.01:0.38

z = Rsoil_DAMM = Node(Float64[DAMM(Tsoil, Msoil) for Tsoil in Tsoil_range, Msoil in Msoil_range])

scene = surface(x, y, z, colormap = :lighttest, transparency = true, alpha = 0.1, shading = false)
wireframe!(scene, x, y, z, overdraw = true, transparency = true, color = (:black, 0.05))
scale!(scene, 5, 200, 5) # Currently needed to rescale Msoil, because its range (00.5 - 0.35) is smaller than Tsoil and Rsoil range
center!(scene)

axis3D = scene[Axis]
axis3D[:ticks][:textsize] = (2000.0,2000.0,2000.0)
# axis3D.names.axisnames = ("Tsoil (°C)", "Msoil (m3 m-3)","Rsoil (umol m-2 s-1)")
# axis3D[:names][:textsize] = (2000.0,2000.0,2000.0) # same as axis.names.textsize

# Slider for kMSx parameter
kMSx_slider = slider(1e-8:1e-9:1e-6)
scene_s = vbox(
     hbox(kMSx_slider),
     hbox(
         scene,
     )
 )
 RecordEvents(scene_s, "output")

# Move the slider, then run these 3 lines to update the figure
kMSx = Observables.async_latest(kMSx_slider[end][:value]) 
kMSx = kMSx[]
z[] = Float64[DAMM(Tsoil, Msoil) for Tsoil in Tsoil_range, Msoil in Msoil_range] 


# TEST
# on(kMSx_slider[end][:value]) do val
#	kMSx = val
#	z[] = Float64[DAMM(Tsoil, Msoil) for Tsoil in Tsoil_range, Msoil in Msoil_range] 
# end



