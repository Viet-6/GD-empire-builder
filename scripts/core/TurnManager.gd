class_name TurnManager
extends Node

signal turn_changed(new_turn)
signal month_changed(new_month)
signal year_changed(new_year)

var current_turn: int = 1
var current_month: int = 1
var current_year: int = 2024
var weeks_per_month: int = 4

func advance_turn():
	current_turn += 1
	var week_of_year = current_turn % (12 * weeks_per_month)
	
	# Simple calendar logic
	if current_turn % weeks_per_month == 1:
		current_month += 1
		if current_month > 12:
			current_month = 1
			current_year += 1
			emit_signal("year_changed", current_year)
		emit_signal("month_changed", current_month)
		
	emit_signal("turn_changed", current_turn)
	print("Turn Advanced: Y%d M%d W%d (Total Turn: %d)" % [current_year, current_month, (current_turn % 4) + 1, current_turn])
