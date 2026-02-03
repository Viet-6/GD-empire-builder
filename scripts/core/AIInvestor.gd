class_name AIInvestor
extends Node

@export var ai_name: String = "AI Capital"
@export var risk_tolerance: float = 0.5 # 0.0 to 1.0
@export var active: bool = true

var funds: float = 200000.0
# Holdings: company_id -> quantity
var holdings: Dictionary = {}

func process_turn(market_factor: float):
	if not active:
		return
		
	# Analyze market opportunities
	for sector in GameManager.sectors:
		for company in sector.companies:
			_analyze_company(company)

func _analyze_company(company: Company):
	# Very simple decision logic
	# If growth is good and we have funds, buy.
	# If valuation dropped or we want profit, sell.
	
	var should_buy = company.growth_rate > 0.04 and funds > 10000
	var should_sell = company.growth_rate < 0.02 and holdings.get(company.id, 0) > 0
	
	if should_buy and randf() < risk_tolerance:
		_buy_stock(company)
	elif should_sell:
		_sell_stock(company)

func _buy_stock(company: Company):
	var amount = 100 + (randi() % 500)
	var price_per_share = company.valuation / 1000000.0
	var cost = price_per_share * amount
	
	if funds >= cost:
		funds -= cost
		holdings[company.id] = holdings.get(company.id, 0) + amount
		# Influence Market: Buying increases valuation slightly
		company.valuation *= 1.001 
		print("%s Bought %d shares of %s" % [ai_name, amount, company.name])

func _sell_stock(company: Company):
	var amount = holdings[company.id] / 2 # Sell half
	if amount > 0:
		var price_per_share = company.valuation / 1000000.0
		funds += price_per_share * amount
		holdings[company.id] -= amount
		# Influence Market: Selling decreases valuation slightly
		company.valuation *= 0.999
		print("%s Sold %d shares of %s" % [ai_name, amount, company.name])
