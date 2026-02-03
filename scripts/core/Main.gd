extends Control

@onready var trading_ui_scene = preload("res://scenes/TradingUI.tscn")

func _ready():
	print("Main Scene Ready")
	
	var ui_instance = trading_ui_scene.instantiate()
	add_child(ui_instance)
	
	# Simulate a few turns
	GameManager.advance_turn()
	await get_tree().create_timer(0.5).timeout
	GameManager.advance_turn()

func _on_advance_turn_pressed():
	GameManager.advance_turn()
