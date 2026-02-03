class_name NewsManager
extends Node

signal news_event_occurred(headline: String, effects: Dictionary, choices: Array)

# Enum for Choice Outcome
enum { NO_EFFECT, SECTOR_BOOST, SECTOR_CRASH }

var possible_events = [
	{
		"headline": "Tech Boom: AI Breakthrough!",
		"sector_id": "tech",
		"modifier": 1.5,
		"duration": 4,
		"choices": []
	},
	{
		"headline": "Market Crash: Global Recession",
		"sector_id": "all",
		"modifier": 0.7,
		"duration": 8,
		"choices": []
	},
	{
		"headline": "Regulatory Comission Investigation",
		"sector_id": "finance",
		"modifier": 1.0, # Depends on choice
		"duration": 0,
		"choices": [
			{"text": "Cooperate (Valuation -10%)", "effect_type": SECTOR_CRASH, "val": 0.9},
			{"text": "Bribe Officials (Valuation +10%)", "effect_type": SECTOR_BOOST, "val": 1.1}
		]
	}
	},
	{
		"headline": "Sports Season Cancelled due to Strike",
		"sector_id": "sports",
		"modifier": 0.5,
		"duration": 2
	},
	{
		"headline": "Restaurant Health Inspection Scanadals",
		"sector_id": "restaurant",
		"modifier": 0.8,
		"duration": 3
	}
]

func check_for_news(turn: int):
	# 10% chance of news
	if randf() < 0.1:
		var event = possible_events.pick_random()
		emit_signal("news_event_occurred", event["headline"], event, event.get("choices", []))
		print("NEWS: %s" % event["headline"])
		
		# Only apply immediate effect if no choices (or apply base effect)
		apply_event_effect(event)

func resolve_choice(effect_type, val, sector_id="finance"):
	# Simplified resolve logic
	var modifier = 1.0
	if effect_type == SECTOR_BOOST:
		modifier = val
	elif effect_type == SECTOR_CRASH:
		modifier = val
		
	var event = {"sector_id": sector_id, "modifier": modifier}
	apply_event_effect(event)
	print("Choice Resolved: Modifier %.2f" % modifier)

func apply_event_effect(event):
	# Simplify: just apply immediate valuation change for now
	# A more complex system would store active modifiers
	var target_sector = event["sector_id"]
	var modifier = event["modifier"]
	
	for sector in GameManager.sectors:
		if target_sector == "all" or sector.id == target_sector:
			for company in sector.companies:
				company.valuation *= modifier
				print("  -> Effect applied to %s: Valuation adjusted." % company.name)
