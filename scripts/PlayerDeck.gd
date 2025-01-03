extends Node2D

class_name PlayerDeck

const CARD_WIDTH : float = 80.0

enum {
	CARD_OFFSET = 80,
	CARD_MIN_OFFSET = 70
}

# Onready variables
onready var _container: Node = $CardContainer


# Adds a card to the player deck.
# @param card: The card to be added to the deck.
func add_card(card: Card) -> void:
	card.position = global_position


# Repositions the cards based on the number of cards in the container.
# If there are 7 or more cards, it uses a smaller offset.
# If a card is going to overflow horizontally, it moves to the next row.
func reposition_cards() -> void:
	var card_count : int = _container.get_child_count()
	var offset : int = CARD_OFFSET
	var screen_width : float = get_viewport().size.x
	var row: int = 0  
	var x_position: float = 0
	
	# If there are 7 or more cards, use a smaller offset
	if card_count >= 7:
		offset = CARD_MIN_OFFSET
	
	
	for i in range(card_count):
		var card: Node2D = _container.get_child(i)
		
		if x_position + CARD_WIDTH > screen_width:
			row += 1
			x_position = 0
		
		var y_position: float = row * (CARD_MIN_OFFSET)
		
		card.position = Vector2(x_position, y_position)
		
		x_position +=  offset


# Signal handler for when the child order changes in the container.
# Repositions the cards after the order has changed.
func _on_card_container_child_order_changed() -> void:
	reposition_cards()

