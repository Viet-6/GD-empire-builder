extends Node

# Autoload Name: GameManager

var turn_manager: TurnManager
var market: Market
var news_manager: NewsManager
var player_portfolio: Portfolio
var sectors: Array[Sector] = []

func _ready():
	print("GameManager Initialized")
	turn_manager = TurnManager.new()
	add_child(turn_manager)
	
	market = Market.new()
	add_child(market)
	
	news_manager = NewsManager.new()
	add_child(news_manager)
	
	player_portfolio = Portfolio.new()
	add_child(player_portfolio)
	
	# Connect signals
	turn_manager.turn_changed.connect(_on_turn_changed)
	turn_manager.month_changed.connect(_on_month_changed)
	
	# Initialize test data
	_initialize_test_data()

func _initialize_test_data():
	var tech_sector = Sector.new("Technology", "tech")
	var finance_sector = Sector.new("Financial", "finance")
	
	sectors.append(tech_sector)
	sectors.append(finance_sector)
	
	var comp1 = Company.new("NanoTech Solutions", "tech")
	tech_sector.add_company(comp1)
	market.register_company(comp1) # Register with market
	
	var comp2 = Company.new("Global Bank", "finance")
	finance_sector.add_company(comp2)
	market.register_company(comp2) # Register with market
	
	# --- Phase 3 Additions ---
	var ent_sector = EntertainmentSector.new("Entertainment", "entertainment")
	sectors.append(ent_sector)
	var movie_studio = Company.new("Star Studios", "entertainment")
	ent_sector.add_company(movie_studio)
	market.register_company(movie_studio)
	
	var sports_sector = SportsSector.new("Sports", "sports")
	sectors.append(sports_sector)
	var football_club = Company.new("United FC", "sports")
	sports_sector.add_company(football_club)
	market.register_company(football_club)
	
	var food_sector = RestaurantSector.new("Restaurants", "restaurant")
	sectors.append(food_sector)
	var burger_chain = Company.new("Burger Kingpin", "restaurant")
	food_sector.add_company(burger_chain)
	market.register_company(burger_chain)
	
	print("Test Data Initialized: %d Sectors" % sectors.size())

func _on_turn_changed(turn: int):
	print("GameManager processing turn %d" % turn)
	# Process economy
	var global_economic_factor = 1.0 # Could be randomized
	
	# Process News
	news_manager.check_for_news(turn)
	
	for sector in sectors:
		sector.process_sector_turn(global_economic_factor)

func _on_month_changed(month: int):
	print("GameManager: Month Changed to %d" % month)
	for sector in sectors:
		if sector.has_method("update_month"):
			sector.update_month(month)

func advance_turn():
	turn_manager.advance_turn()
