extends Node

# Autoload Name: GameManager

var turn_manager: TurnManager
var sectors: Array[Sector] = []

func _ready():
	print("GameManager Initialized")
	turn_manager = TurnManager.new()
	add_child(turn_manager)
	
	# Connect signals
	turn_manager.turn_changed.connect(_on_turn_changed)
	
	# Initialize test data
	_initialize_test_data()

func _initialize_test_data():
	var tech_sector = Sector.new("Technology", "tech")
	var finance_sector = Sector.new("Financial", "finance")
	
	sectors.append(tech_sector)
	sectors.append(finance_sector)
	
	var comp1 = Company.new("NanoTech Solutions", "tech")
	tech_sector.add_company(comp1)
	
	var comp2 = Company.new("Global Bank", "finance")
	finance_sector.add_company(comp2)
	
	print("Test Data Initialized: %d Sectors" % sectors.size())

func _on_turn_changed(turn: int):
	print("GameManager processing turn %d" % turn)
	# Process economy
	var global_economic_factor = 1.0 # Could be randomized
	
	for sector in sectors:
		sector.process_sector_turn(global_economic_factor)

func advance_turn():
	turn_manager.advance_turn()
