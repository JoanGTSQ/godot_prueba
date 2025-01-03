extends Node2D

class_name EnemyDeck


enum {
	CARD_OFFSET = 81,
	CARD_MIN_OFFSET = 70
}

# Onready variables
onready var _container : Node = $CardContainer


# Adds a card to the enemy's deck.
# The card is positioned at the global position of the deck.
# @param card Card The card to add to the deck.
func add_card(card : Card) -> void:
	card.position = global_position


# Repositions all cards in the deck based on their count.
# If there are more than 7 cards, it uses a smaller offset for better spacing.
# Cards that would overflow horizontally move to the next row.
func reposition_cards() -> void:
	var card_count: int = _container.get_child_count()
	var screen_width: float = get_viewport().size.x
	var row: int = 0
	var x_position: float = 0.0
	
	
	for i in range(card_count):
		var card: Node2D = _container.get_child(i)
		
		if x_position + CARD_OFFSET > screen_width:
			row += 1
			x_position = 0  
		
		var y_position: float = -(row * (CARD_MIN_OFFSET))
		
		card.position = Vector2(x_position, y_position)
		
		x_position +=  CARD_OFFSET


# Signal handler for when the child order in the container changes.
func _on_card_container_child_order_changed() -> void:
	reposition_cards()
