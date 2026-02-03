class_name SaveSystem
extends RefCounted

const SAVE_PATH = "user://savegame.save"

static func save_game():
	var save_data = {
		"version": "1.0",
		"date": Time.get_datetime_string_from_system(),
		"turn_data": {
			"current_turn": GameManager.turn_manager.current_turn,
			"current_month": GameManager.turn_manager.current_month,
			"current_year": GameManager.turn_manager.current_year
		},
		"portfolio": {
			"cash": GameManager.player_portfolio.cash,
			"holdings": GameManager.player_portfolio.holdings
		},
		"companies": {}
	}
	
	# Save company valuations
	for sector in GameManager.sectors:
		for company in sector.companies:
			save_data["companies"][company.id] = {
				"valuation": company.valuation,
				"funds": company.funds
			}
			
	var json_string = JSON.stringify(save_data)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		print("Game Saved to %s" % SAVE_PATH)
		return true
	else:
		printerr("Failed to save game.")
		return false

static func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return false
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		printerr("JSON Parse Error: ", json.get_error_message())
		return false
		
	var data = json.get_data()
	
	# Restore Turn Data
	GameManager.turn_manager.current_turn = data["turn_data"]["current_turn"]
	GameManager.turn_manager.current_month = data["turn_data"]["current_month"]
	GameManager.turn_manager.current_year = data["turn_data"]["current_year"]
	
	# Restore Portfolio
	GameManager.player_portfolio.cash = data["portfolio"]["cash"]
	GameManager.player_portfolio.holdings = data["portfolio"]["holdings"]
	GameManager.player_portfolio.emit_signal("funds_changed", GameManager.player_portfolio.cash)
	
	# Restore Company Data
	var company_data = data["companies"]
	for sector in GameManager.sectors:
		for company in sector.companies:
			if company_data.has(company.id):
				company.valuation = company_data[company.id]["valuation"]
				company.funds = company_data[company.id]["funds"]
				
	print("Game Loaded Successfully")
	GameManager.turn_manager.emit_signal("turn_changed", GameManager.turn_manager.current_turn)
	return true
