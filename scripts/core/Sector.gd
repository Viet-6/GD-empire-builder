class_name Sector
extends Resource

@export var name: String = "General"
@export var id: String = "general"
@export var base_growth_rate: float = 0.03
@export var volatility: float = 0.1

var companies: Array[Company] = []

func _init(p_name: String = "", p_id: String = ""):
	if p_name != "":
		name = p_name
	if p_id != "":
		id = p_id

func add_company(company: Company):
	if not company in companies:
		companies.append(company)

func get_sector_valuation() -> float:
	var total = 0.0
	for company in companies:
		total += company.valuation
	return total

func process_sector_turn(global_economic_factor: float):
	# Sector specific events could happen here
	var sector_performance = randf_range(1.0 - volatility, 1.0 + volatility)
	var final_factor = global_economic_factor * sector_performance
	
	print("Processing Sector: %s (Factor: %.2f)" % [name, final_factor])
	
	for company in companies:
		company.process_turn(final_factor)
