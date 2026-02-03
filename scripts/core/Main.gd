extends Control

func _ready():
	print("Main Scene Ready")
	# Simulate a few turns
	GameManager.advance_turn()
	await get_tree().create_timer(0.5).timeout
	GameManager.advance_turn()

func _on_advance_turn_pressed():
	GameManager.advance_turn()
