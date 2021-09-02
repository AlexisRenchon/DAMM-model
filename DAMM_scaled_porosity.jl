# The Dual Arrhenius and Michealis-Menten (DAMM) model, Davidson et al. 2012
function DAMM(x, p)
     # Constants
	R = 8.314472e-3 # Universal gas constant, kJ K⁻¹ mol⁻¹
	O₂ₐ = 0.209 # Volume of O₂ in the air, L L⁻¹
	Dₗᵢ = 3.17 # Diffusion coefficient of substrate in liquid phase, dimensionless
	Dₒₐ = 1.67 # Diffusion coefficient of oxygen in air, dimensionless
	pₛₓ = 0.024 # Fraction of soil carbon that is considered soluble
     # Independent variables
	Tₛ = x[:, 1] # Soil temperature, °C
	θ = x[:, 2] # Soil moisture, m³ m⁻³
     # Parameters 
	αₛₓ = 1e9*p[1] # Pre-exponential factor, mgC cm⁻³ h⁻¹
     	# Eaₛₓ = p[2] # Activation energy, kJ mol⁻¹
	Eaₛₓ = 64.5 # Activation energy, kJ mol⁻¹
	kMₛₓ = 1e-6*p[2] # Michaelis constant, gC cm⁻³
    	kMₒ₂ = 1e-4*p[3] # Michaelis constant for O₂, L L⁻¹
	# porosity = p[5] # 1 - soil buld density / soil particle density
	porosity = p[4]
	# Sxₜₒₜ = 1e-2*p[5] # Total soil carbon, gC cm⁻³
	Sxₜₒₜ = 0.02 # Total soil carbon, gC cm⁻³
     # Soil moisture can not be bigger than porosity
	θ[θ.>p[4]] .= p[4]
     # DAMM model
	Vmax = @. (αₛₓ * exp(-Eaₛₓ/(R * (273.15 + Tₛ)))) # Maximum potential rate of respiration
     	Sₓ = @. pₛₓ * Sxₜₒₜ * Dₗᵢ * θ^3 # All soluble substrate, gC cm⁻³
	MMₛₓ = @. Sₓ / (kMₛₓ + Sₓ) # Availability of substrate factor, 0-1 
	O₂ = @. Dₒₐ * O₂ₐ * ((porosity - θ)^(4/3)) # Oxygen concentration
	MMₒ₂ = @. O₂ / (kMₒ₂ + O₂) # Oxygen limitation factor, 0-1
	Resp = @. Vmax * MMₛₓ * MMₒ₂ # Respiration, mg C cm⁻³ hr⁻¹
	Respc = Resp .* 2314.8148 # Respiration, μmol CO₂ m⁻² s⁻¹
end
