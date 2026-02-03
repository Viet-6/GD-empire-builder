class_name NewsManager
extends Node

signal news_event_occurred(headline, effects)

var possible_events = [
	{
		"headline": "Tech Boom: AI Breakthrough!",
		"sector_id": "tech",
		"modifier": 1.5,
		"duration": 4
	},
	{
		"headline": "Market Crash: Global Recession",
		"sector_id": "all",
		"modifier": 0.7,
		"duration": 8
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
		emit_signal("news_event_occurred", event["headline"], event)
		print("NEWS: %s" % event["headline"])
		apply_event_effect(event)

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
