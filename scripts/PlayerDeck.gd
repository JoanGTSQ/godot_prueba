extends Node2D

class_name PlayerDeck

# Private variables 
var _card_offset: int = 80
var _card_offset_min: int = 70

# Onready variables
onready var _container: Node = $CardContainer


# Adds a card to the player deck.
# @param card: The card to be added to the deck.
func add_card(card: Card) -> void:
	card.position = global_position


# Repositions the cards based on the number of cards in the container.
# If there are 7 or more cards, it uses a smaller offset.
func reposition_cards() -> void:
	var card_count: int = _container.get_child_count()
	var offset: int = _card_offset
	
	# If there are 7 or more cards, use a smaller offset
	if card_count >= 7:
		offset = _card_offset_min
	
	for i in range(card_count):
		var card: Node = _container.get_child(i)
		card.position = Vector2(i * offset, 0)


# Signal handler for when the child order changes in the container.
# Repositions the cards after the order has changed.
func _on_CardContainer_child_order_changed() -> void:
	reposition_cards()
