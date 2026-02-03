extends Control

@onready var company_list = $VBoxContainer/CompanyList
@onready var funds_label = $VBoxContainer/FundsLabel

var selected_company: Company = null

func _ready():
	# Connect to signals
	GameManager.player_portfolio.funds_changed.connect(_on_funds_changed)
	_on_funds_changed(GameManager.player_portfolio.cash)
	
	_refresh_company_list()

func _on_funds_changed(new_amount: float):
	funds_label.text = "Funds: $%.2f" % new_amount

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
