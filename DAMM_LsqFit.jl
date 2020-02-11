# Least square error fit of the DAMM model to data
using LsqFit, CSV

# Load fixed param
EaSx = 53 #
R = 8.314472*10^-3 # Universal gas constant
Dl = 3.17 # Diffusion coeff of substrate in liquid phase
Sxt = 0.0125 # Soil C content
p = 2.4*10^-2 # Fraction of soil C that is considered soluble
Dgas = 1.67 # Diffusion coefficient of oxygen in air
Db = 1.53 # Soil bulk density !! DAMM complex if SWC > 0.365. old 1.5396
Dp = 2.52 # Soil particle density

# DAMM model, !for the algorithm to work, Param are scaled to be of similar magnitude
@. multimodel(Ind_var, Param) = (1e6*Param[1]*exp(-EaSx/(R*(273.15+Ind_var[:, 1]))))* 
(((p*Sxt)*Dl*Ind_var[:, 2]^3)/(1e-8*Param[2]+((p*Sxt)*Dl*Ind_var[:, 2]^3)))* 
((Dgas*0.209*(1-Db/Dp-Ind_var[:, 2])^[4/3])/ 
(1e-3*Param[3]+(Dgas*0.209*(1-Db/Dp-Ind_var[:, 2])^[4/3])))* 
10000*10/1000/12*1e6/60/60 

# Example
Param = Param_ini = [2.0,3.46,2.0] # Scaled Param, as explained above. AlphaSx, kMsx, kMo2
Ind_var = [25.0 0.3; 27 0.25]
multimodel(Ind_var, Param)

# Load data
df = CSV.read("Input\\AUCum_Reco_Rsoil_soilvars_2014_2017.csv",dateformat="mm/dd/yyyy HH:MM")
SWC_3 = df.SWC_R3; Tsoil_3 = df.Ts_R3; Rsoil_3 = Dep_var = df.Rsoil_R3
Ind_var = hcat(Tsoil_3, SWC_3)

# Fit DAMM to data
# Need to load data first... TO DO
fit = curve_fit(multimodel, Ind_var, Dep_var, Param_ini) # For DAMM, Ind_var is Tsoil and SWC, Dep_var is Rsoil
Param_fit = coef(fit)
Modeled_data = multimodel(Ind_var,Param_fit)

