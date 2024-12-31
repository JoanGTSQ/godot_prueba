extends Node2D

class_name EnemyDeck


enum {
	CARD_OFFSET = 81,
	CARD_MIN_OFFSET = 70
}

# Onready variables
onready var _container : Node = $CardContainer


# Adds a card to the deck.
# @param card The card to add.
func add_card(card : Card) -> void:
	card.position = global_position


# Repositions the cards based on the number of cards in the container.
# If there are 7 or more cards, it uses a smaller offset.
# If a card is going to overflow horizontally, it moves to the next row.
func reposition_cards() -> void:
	var card_count: int = _container.get_child_count()
	var screen_width: int = get_viewport().size.x  # Screen width in Godot 3.6
	
	
	var row: int = 0  # Current row index
	var x_position: float = 0  # Current x position within the row
	for i in range(card_count):
		var card: Node2D = _container.get_child(i)
		
		if x_position + CARD_OFFSET > screen_width:
			row += 1
			x_position = 0  # Reset x position for the new row
		
		var y_position: float = -(row * (CARD_MIN_OFFSET))
		
		card.position = Vector2(x_position, y_position)
		
		x_position +=  CARD_OFFSET


# Signal handler for when the child order in the container changes.
func _on_CardContainer_child_order_changed() -> void:
	reposition_cards()
