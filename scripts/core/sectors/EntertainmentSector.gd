class_name EntertainmentSector
extends Sector

# Hit mechanism: randomly trigger large growth spikes
@export var hit_chance: float = 0.05 # 5% chance per turn
@export var hit_multiplier: float = 2.0 # Valuation doubles on hit

func process_sector_turn(global_economic_factor: float):
	for company in companies:
		# Base processing with higher volatility
		var volatility_factor = randf_range(0.8, 1.2)
		var company_factor = global_economic_factor * volatility_factor
		
		# Check for "Hit"
		if randf() < hit_chance:
			print("HIT EVENT! %s released a blockbuster!" % company.name)
			company_factor *= hit_multiplier
			
		company.process_turn(company_factor)
