# Parameters to fit to the data
AlphaSx = 3e8 
kMSx = 2e-8 
kMO2 = 3e-3 

# Fixed parameters, values as in John Drake et al., 2018
EaSx = 62
R = 8.314472e-3 # Universal gas constant, kJ K-1 mol-1
O2airfrac = 0.209 # L O2 L-1 air
BD = 1.5396 # Soil bulk density  
PD = 2.52 # Soil particle density
porosity = 1-BD/PD # total porosity
Sxtot = 0.0125 # Soil C content (g/cm3) 
psx = 2.4e-2 # Fraction of soil C that is considered soluble
Dliq = 3.17 # Diffusion coeff of substrate in liquid phase
Dgas = 1.67 # Diffusion coefficient of oxygen in air
Soildepth = 10 # effective soil depth in cm

