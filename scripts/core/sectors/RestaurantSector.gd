class_name RestaurantSector
extends Sector

# Trend mechanism: Popularity trends that last for a while
@export var trend_change_chance: float = 0.1
@export var current_trend_modifier: float = 1.0

func process_sector_turn(global_economic_factor: float):
	# Chance to change the overall sector trend
	if randf() < trend_change_chance:
		current_trend_modifier = randf_range(0.9, 1.15)
		print("Restaurant Trend Changed: %.2f" % current_trend_modifier)
		
	for company in companies:
		# Restaurants are very sensitive to global economy (disposable income)
		# But 'trend' buffers or enhances it
		var final_factor = global_economic_factor * current_trend_modifier
		company.process_turn(final_factor)
