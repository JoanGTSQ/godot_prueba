extends Node2D

const CARD : PackedScene = preload("res://scenes/Card.tscn")

var values : Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
var colors : Array = [Color(0.9, 0.3, 0.3), Color(0.4, 0.6, 0.9), Color(0.4, 0.9, 0.6), Color(0.9, 0.9, 0.4)]
var special_values : Array = ["+2", "SKIP", "SWAP"]


onready var deck : Array = []
onready var discard_pile : Array = []


# Sets up the deck, shuffles it, and deals the initial card.
func set_up() -> void:
	_initialize_deck()
	_shuffle_deck()
	_deal_initial_card()


# Draws the top card from the deck.
# @return Card The drawn card.
func draw() -> Card:
	if deck.size() <= 4:
		_recycle_discard_pile()
	var card : Card = deck.pop_back()
	return card


# Adds a card to the discard pile.
# @param card The card to discard.
func discard_card(card : Card) -> void:
	card.set_filter(false)
	discard_pile.append(card)


# Retrieves the current card on top of the discard pile.
# @return Card The current card or an empty dictionary if no cards exist.
func get_current_card() -> Card:
	if discard_pile.size() == 0:
		print("No cards in the discard pile.")
		return null
	return discard_pile[-1]


# Validates if a card can be played based on the current discard pile card.
# @param card The card to validate.
# @return bool True if valid, false otherwise.
func is_valid_card(card : Card) -> bool:
	return discard_pile[-1].get_color() == card.get_color() or discard_pile[-1].get_value() == card.get_value()


# Frees all the cards in the deck.
func destroy() -> void:
	for card in deck:
		card.queue_free()


# Creates and populates the deck with cards based on values and colors.
func _initialize_deck() -> void:
	deck.clear()
	discard_pile.clear()

	for color in colors:
		for value in values:
			var new_card : Card = CARD.instance()
			add_child(new_card)
			new_card.set_up(color, str(value), false)
			deck.append(new_card)

		for special_value in special_values:
			var new_card : Card = CARD.instance()
			add_child(new_card)
			new_card.set_up(color, str(special_value), true)
			deck.append(new_card)


# Randomizes and shuffles the deck to ensure randomness in card order.
func _shuffle_deck() -> void:
	randomize()
	deck.shuffle()


# Recycles the discard pile back into the deck, leaving the top card.
func _recycle_discard_pile() -> void:
	if discard_pile.size() <= 1:
		print("Not enough cards in the discard pile to recycle.")
		return

	# Recycle all but the last card in the discard pile
	var discard_count = discard_pile.size() - 1
	for _i in range(discard_count):
		var card = discard_pile.pop_front()  # Remove the first card
		deck.append(card)  # Add it back to the deck

	_shuffle_deck()


# Deals the initial card to the discard pile and handles special cases.
func _deal_initial_card() -> void:
	var initial_card : Card = draw()
	discard_card(initial_card)

	# Loop until the drawn card is not special.
	while initial_card.is_special_card():
		print("Special card drawn, drawing again...")
		initial_card = draw()
		discard_card(initial_card)
