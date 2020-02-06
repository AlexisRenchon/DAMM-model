function DAMM(Tsoil::Float64, Msoil::Float64) 
	Sx = Sxtot * psx * Dliq * Msoil^3
	O2 = Dgas * O2airfrac * ((porosity - Msoil)^(4/3))
	MMSx = Sx / (kMSx + Sx)
	MMO2 = O2 / (kMO2 + O2)
	VmaxSx = (AlphaSx * exp(-EaSx/(R * (273.15 + Tsoil))))
	Resp = VmaxSx * MMSx * MMO2 # in mgC g-1 hr-1
	areaCflux = 10000 * Soildepth * Resp # in mgC m-2 hr-1
	Rsoil = areaCflux / 1000 / 12 * 1e6 / 60 / 60 # in umol CO2 m-2 s-1
end
