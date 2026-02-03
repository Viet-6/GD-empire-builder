class_name SportsSector
extends Sector

# Seasonality: Strong performance during season, weak otherwise
@export var season_start_month: int = 8 # August
@export var season_end_month: int = 5 # May
@export var in_season_multiplier: float = 1.2
@export var off_season_multiplier: float = 0.8

var current_month: int = 1

func update_month(month: int):
	current_month = month

func is_in_season() -> bool:
	if season_start_month < season_end_month:
		return current_month >= season_start_month and current_month <= season_end_month
	else:
		# Season crosses year boundary (e.g. Aug to May)
		return current_month >= season_start_month or current_month <= season_end_month

func process_sector_turn(global_economic_factor: float):
	var season_factor = off_season_multiplier
	if is_in_season():
		season_factor = in_season_multiplier
		
	# Add some randomness suitable for sports (winning/losing streaks)
	var accumulated_factor = global_economic_factor * season_factor
	
	print("Sports Sector Processing (Month %d, In Season: %s)" % [current_month, is_in_season()])
	
	for company in companies:
		# Individual teams perform better/worse
		var team_performance = randf_range(0.9, 1.1) 
		company.process_turn(accumulated_factor * team_performance)
