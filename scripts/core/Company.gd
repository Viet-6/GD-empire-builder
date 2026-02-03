class_name Company
extends Resource

signal stats_changed

@export var name: String = "Startup"
@export var id: String = ""
@export var sector_id: String = ""
@export var valuation: float = 100000.0
@export var funds: float = 50000.0
@export var revenue_last_year: float = 0.0
@export var growth_rate: float = 0.05 # 5% growth
@export var dividend_yield: float = 0.02 # 2% annual yield paid quarterly

# Market sentiment modifier (0.0 to 1.0+)
var sentiment_modifier: float = 1.0

func _init(p_name: String = "", p_sector_id: String = ""):
	if p_name != "":
		name = p_name
	if p_sector_id != "":
		sector_id = p_sector_id
	
	# Generate unique ID if not provided (simple implementation)
	if id == "":
		id = name.to_lower().replace(" ", "_") + "_" + str(randi() % 10000)

func process_turn(market_factor: float):
	# Simplified economic simulation
	var revenue = (valuation * 0.1) * (1.0 + growth_rate) * market_factor * sentiment_modifier
	funds += revenue * 0.2 # Profit margin
	valuation *= (1.0 + growth_rate)
	
	emit_signal("stats_changed")
	print("Processed turn for %s. New Valuation: %.2f" % [name, valuation])
