# Parameters to fit to the data
AlphaSx = 3e8 # pre-exponential factor, umol h-1 g-1
# kMSx = 2e-6 # constant, umol L-1
kMO2 = 3e-3 # Michaelis constant for O2, L L-1

# Fixed parameters, values as in John Drake et al., 2018
EaSx = 62 # Activation energy, kJ mol-1
R = 8.314472e-3 # Universal gas constant, kJ K-1 mol-1
O2airfrac = 0.209 # volume of O2 in the air, L L-1
BD = 1.5396 # Soil bulk density, g cm-3  
PD = 2.52 # Soil particle density, g cm-3
porosity = 1-BD/PD # total porosity
Sxtot = 0.0125 # Soil C content, g cm-3 
psx = 2.4e-2 # Fraction of soil C that is considered soluble
Dliq = 3.17 # Diffusion coeff of substrate in liquid phase, dimensionless
Dgas = 1.67 # Diffusion coefficient of oxygen in air, dimensionless
Soildepth = 10 # effective soil depth, cm
