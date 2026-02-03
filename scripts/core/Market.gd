class_name Market
extends Node

# Dictionary mapping company_id to Array of price history (floats)
var price_history: Dictionary = {}

func register_company(company: Company):
	if not price_history.has(company.id):
		price_history[company.id] = []
		# Add initial valuation
		record_price(company)
		
	# Connect to stats_changed to record history
	if not company.stats_changed.is_connected(_on_company_stats_changed):
		company.stats_changed.connect(_on_company_stats_changed.bind(company))

func record_price(company: Company):
	if price_history.has(company.id):
		price_history[company.id].append(company.valuation)
		# Keep history limit to avoid memory bloat (e.g., last 52 weeks)
		if price_history[company.id].size() > 104: # 2 years
			price_history[company.id].pop_front()

func _on_company_stats_changed(company: Company):
	record_price(company)

func get_history(company_id: String) -> Array:
	return price_history.get(company_id, [])
