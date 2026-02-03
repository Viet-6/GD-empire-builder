class_name Portfolio
extends Node

signal funds_changed(new_amount)
signal holdings_changed(company_id, new_quantity)

var cash: float = 100000.0 # Starting Cash
# Dictionary mapping company_id to quantity (int)
var holdings: Dictionary = {}

func get_cash() -> float:
	return cash

func get_holdings(company_id: String) -> int:
	return holdings.get(company_id, 0)

func can_afford(cost: float) -> bool:
	return cash >= cost

func buy_stock(company: Company, quantity: int) -> bool:
	if quantity <= 0:
		return false
		
	# Simple valuation-based price for now (1 share = 0.0001% of valuation or arbitrary unit)
	# Let's assume price per share is derived from valuation / total_shares (fixed at 1M for now)
	var price_per_share = company.valuation / 1000000.0
	var total_cost = price_per_share * quantity
	
	if can_afford(total_cost):
		cash -= total_cost
		var current_qty = holdings.get(company.id, 0)
		holdings[company.id] = current_qty + quantity
		
		emit_signal("funds_changed", cash)
		emit_signal("holdings_changed", company.id, holdings[company.id])
		print("Bought %d shares of %s at %.2f. Cash remaining: %.2f" % [quantity, company.name, price_per_share, cash])
		return true
	else:
		print("Insufficient funds to buy %s" % company.name)
		return false

func sell_stock(company: Company, quantity: int) -> bool:
	if quantity <= 0:
		return false
		
	var current_qty = holdings.get(company.id, 0)
	if current_qty >= quantity:
		var price_per_share = company.valuation / 1000000.0
		var total_value = price_per_share * quantity
		
		cash += total_value
		holdings[company.id] = current_qty - quantity
		
		emit_signal("funds_changed", cash)
		emit_signal("holdings_changed", company.id, holdings[company.id])
		print("Sold %d shares of %s at %.2f. Cash: %.2f" % [quantity, company.name, price_per_share, cash])
		return true
	else:
		print("Not enough shares to sell %s" % company.name)
		return false
