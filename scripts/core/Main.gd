extends Control

@onready var trading_ui_scene = preload("res://scenes/TradingUI.tscn")

# UI Nodes
@onready var save_btn = $GameUI/TopBar/SaveButton
@onready var load_btn = $GameUI/TopBar/LoadButton
@onready var next_turn_btn = $GameUI/TopBar/AdvanceTurnButton
@onready var news_label = $GameUI/TopBar/NewsLabel

func _ready():
	print("Main Scene Ready")
	
	var ui_instance = trading_ui_scene.instantiate()
	# Add below top bar
	ui_instance.position.y = 50
	add_child(ui_instance)
	
	# Connect Buttons
	save_btn.pressed.connect(_on_save_pressed)
	load_btn.pressed.connect(_on_load_pressed)
	next_turn_btn.pressed.connect(_on_next_turn_pressed)
	
	# Connect News
	GameManager.news_manager.news_event_occurred.connect(_on_news_event)
	
	# Initial Turn
	GameManager.advance_turn()

func _on_save_pressed():
	SaveSystem.save_game()

func _on_load_pressed():
	if SaveSystem.load_game():
		# Refresh UI? Ideally signals handle this
		print("Game Reloaded")

func _on_next_turn_pressed():
	GameManager.advance_turn()
	
func _on_news_event(headline, _effects):
	news_label.text = "NEWS: " + headline
	# Clear after 4 seconds
	await get_tree().create_timer(4.0).timeout
	if news_label.text == "NEWS: " + headline:
		news_label.text = ""
