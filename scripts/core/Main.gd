extends Control

@onready var trading_ui_scene = preload("res://scenes/TradingUI.tscn")

# UI Nodes
@onready var save_btn = $GameUI/TopBar/SaveButton
@onready var load_btn = $GameUI/TopBar/LoadButton
@onready var next_turn_btn = $GameUI/TopBar/AdvanceTurnButton
@onready var news_label = $GameUI/TopBar/NewsLabel

# Choice UI
@onready var choice_panel = $GameUI/ChoicePanel
@onready var choice_title = $GameUI/ChoicePanel/VBox/Title
@onready var choice_desc = $GameUI/ChoicePanel/VBox/Desc
@onready var choice_buttons = $GameUI/ChoicePanel/VBox/Buttons

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
	
func _on_news_event(headline: String, effects: Dictionary, choices: Array):
	news_label.text = "NEWS: " + headline
	
	if choices.size() > 0:
		_show_choice_dialog(headline, choices)
	
	# Clear after 4 seconds
	await get_tree().create_timer(4.0).timeout
	if news_label.text == "NEWS: " + headline:
		news_label.text = ""

func _show_choice_dialog(headline: String, choices: Array):
	choice_panel.visible = true
	choice_title.text = headline
	choice_desc.text = "A decision is required."
	
	# Clear old buttons
	for child in choice_buttons.get_children():
		child.queue_free()
		
	for choice in choices:
		var btn = Button.new()
		btn.text = choice["text"]
		btn.pressed.connect(func(): _on_choice_made(choice))
		choice_buttons.add_child(btn)

func _on_choice_made(choice):
	choice_panel.visible = false
	GameManager.news_manager.resolve_choice(choice["effect_type"], choice["val"])
	print("Choice Selected: %s" % choice["text"])
