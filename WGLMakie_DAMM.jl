using GLMakie, UnicodeFun, SparseArrays, JSServe
using JSServe.DOM

# load DAMM, 3 params + porosity
include("DAMM_scaled_porosity.jl");

L = 40 # resolution
x = collect(range(1, length=L, stop=1))
[append!(x, collect(range(i, length=L, stop=i))) for i = 2:40]
x = reduce(vcat,x)
y = collect(range(0.0, length=L, stop=0.70))
y = repeat(y, outer=L)
x_range = hcat(x, y)

x = Int.(x_range[:, 1])
y_ax = collect(range(0.0, length=L, stop=0.70))
y = collect(range(1, length=L, stop=L))
y = repeat(y, outer=L)
y = Int.(y)
x_ax = collect(range(1, length=L, stop=L))


function create_plot(sliders1, sliders2, sliders3, sliders4)
	fig = Figure(resolution = (1800, 1000))
	#fig

	#ax1 = fig[1, 1] = Axis(fig, title = "Parameters")
	#fig

	#texts = Array{Label}(undef, 4);
	#sliders = [Slider(fig, range = sr) for sr in sliderranges];
#	texts[1] = Label(fig, text= lift(X->string(to_latex("\\alpha_{sx}"), " = ", X,
#			to_latex(" (mgC cm^{-3} h^{-1})")), sliders[1].value), textsize=35, width = Auto(false));
#	texts[2] = Label(fig, text= lift(X->string(to_latex("kM_{sx}"), " = ", round(X, sigdigits = 2),
#			to_latex(" (gC cm^{-3})")), sliders[2].value), textsize=35, width = Auto(false));
#	texts[3] = Label(fig, text= lift(X->string(to_latex("kM_{o2}"), " = ", X,
#			to_latex(" (L L^{-1})")), sliders[3].value), textsize=35, width = Auto(false));
#	texts[4] = Label(fig, text= lift(X->string(to_latex("Porosity"), " = ", X,
#			to_latex(" (m^3 m^{-3})")), sliders[4].value), textsize=35, width = Auto(false));
	#texts[4] = Label(fig, text= lift(X->string(to_latex("E_a"), " = ", X, to_latex(" (kJ mol^{-1})")), sliders[4].value), textsize=35, width = Auto(false));
	#texts[5] = Label(fig, text= lift(X->string(to_latex("S_x"), " = ", X, to_latex(" (gC cm^{-3})")), sliders[5].value), textsize=35, width = Auto(false));
#	vertical_sublayout = fig[1, 1] = vgrid!(
#	    Iterators.flatten(zip(texts, sliders))...;
#	    width = 200, height = 1000);

	ax3D = Axis3(fig[1,2])

	# need DAMM to return NAN instead of bug when SWC > porosity
	# try catch?
	# or condition, if SWC (x[i, 2]) > porosity, return NaN, or force SWC to porosity 

	surface!(ax3D, x_ax, y_ax, lift((AlphaSx, kMSx, kMO2, Porosity)->
		Matrix(sparse(x, y, DAMM(x_range, [AlphaSx, kMSx, kMO2, Porosity]))),
		sliders1.value, sliders2.value, sliders3.value, sliders4.value),
		colormap = Reverse(:Spectral), transparency = true, alpha = 0.2, shading = false) 
		#, limits = Rect(10, 0, 0, 25, 0.4, 20));

	wireframe!(ax3D, x_ax, y_ax, lift((AlphaSx, kMSx, kMO2, Porosity)->
		Matrix(sparse(x, y, DAMM(x_range, [AlphaSx, kMSx, kMO2, Porosity]))),
		sliders1.value, sliders2.value, sliders3.value, sliders4.value),
		   overdraw = true, transparency = true, color = (:black, 0.1));

	ax3D.xlabel = to_latex("T_{soil} (°C)");
	ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
	ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
	zlims!(0, 25)
	ylims!(0, 0.7)
	return fig
end

sr = [0.1:0.1:1, # alpha
	0:1:50, # kMsx
	0:1:50, # kmo2
	0.2:0.05:0.7]; # porosity

function handler(s, r)
	sliders1 = JSServe.Slider(sr[1])
	sliders2 = JSServe.Slider(sr[2])
	sliders3 = JSServe.Slider(sr[3])
	sliders4 = JSServe.Slider(sr[4])
	fig = create_plot(sliders1, sliders2, sliders3, sliders4)
	sl1disp = DOM.div(sliders1) #, style="width: $(size(fig)[2] -250)px")
	sl2disp = DOM.div(sliders2) #, style="width: $(size(fig)[2] -250)px")
	sl3disp = DOM.div(sliders3) #, style="width: $(size(fig)[2] -250)px")
	sl4disp = DOM.div(sliders4) #, style="width: $(size(fig)[2] -250)px")

    return DOM.div(JSServe.Asset(JSServe.dependency_path("styled.css")), sl1disp, sl2disp, sl3disp, sl4disp, fig, style = """
    display: flex;
    fle: flex;
    flex-direction: column;
    align-items: center;
    """)
end

#JSServe.with_session() do s, r
#  return JSServe.record_state_map(s, handler)
#end

# lines below from BasicWGLMakie.jl
AppInteraktive(s, r) = JSServe.record_state_map(s, handler(s, r)).dom
s = JSServe.Session()
states = AppInteraktive(s, nothing)
#sizeof(MsgPack.pack(x)) / 10^6
mkdir("simple")
JSServe.export_standalone(AppInteraktive, "simple")

