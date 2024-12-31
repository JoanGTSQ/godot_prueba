extends Node2D

class_name EnemyDeck

# Constants
const CARD_OFFSET : int = 81

# Onready variables
onready var _container : Node = $CardContainer


# Adds a card to the deck.
# @param card The card to add.
func add_card(card : Card) -> void:
	card.position = global_position


# Repositions all cards in the deck.
func reposition_cards() -> void:
	for i in range(_container.get_child_count()):
		var card : Node2D = _container.get_child(i)
		card.position = Vector2(i * CARD_OFFSET, 0)


# Signal handler for when the child order in the container changes.
func _on_CardContainer_child_order_changed() -> void:
	reposition_cards()
