extends Control

@onready var company_list = $VBoxContainer/CompanyList
@onready var funds_label = $VBoxContainer/FundsLabel
@onready var buy_button = $VBoxContainer/HBoxContainer/BuyButton
@onready var sell_button = $VBoxContainer/HBoxContainer/SellButton

var diversification_label: Label
var selected_company: Company = null

func _ready():
	# Connect to signals
	GameManager.player_portfolio.funds_changed.connect(_on_funds_changed)
	_on_funds_changed(GameManager.player_portfolio.cash)
	
	# Create Diversification Label dynamically
	diversification_label = Label.new()
	$VBoxContainer.add_child(diversification_label)
	$VBoxContainer.move_child(diversification_label, 2) # Place below Funds
	
	buy_button.pressed.connect(_on_buy_pressed)
	sell_button.pressed.connect(_on_sell_pressed)
	
	_refresh_company_list()

func _on_funds_changed(new_amount: float):
	funds_label.text = "Funds: $%.2f" % new_amount
	_update_diversification_label()

func _update_diversification_label():
	if diversification_label:
		var score = GameManager.player_portfolio.calculate_diversification_score()
		var bonus_percent = (score - 1.0) * 100
		diversification_label.text = "Diversification Bonus: +%.0f%%" % bonus_percent

func _refresh_company_list():
	for child in company_list.get_children():
		child.queue_free()
		
	for sector in GameManager.sectors:
		for company in sector.companies:
			var btn = Button.new()
			btn.text = "%s ($%.2f)" % [company.name, company.valuation]
			btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
			btn.pressed.connect(func(): _on_company_selected(company))
			company_list.add_child(btn)

func _on_company_selected(company: Company):
	selected_company = company
	print("Selected: %s" % company.name)

func _on_buy_pressed():
	if selected_company:
		GameManager.player_portfolio.buy_stock(selected_company, 100) # Buy 100 shares

func _on_sell_pressed():
	if selected_company:
		GameManager.player_portfolio.sell_stock(selected_company, 100) # Sell 100 shares
