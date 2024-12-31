extends Node2D

class_name PlayerDeck

# Private variables 
# Constants
enum {
	CARD_OFFSET = 81,
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
# Repositions the cards based on the number of cards in the container.
# If there are 7 or more cards, it uses a smaller offset.
# If a card is going to overflow horizontally, it moves to the next row.
func reposition_cards() -> void:
	var card_count: int = _container.get_child_count()
	var offset: int = CARD_OFFSET
	var screen_width: int = get_viewport().size.x  # Screen width in Godot 3.6
	
	# If there are 7 or more cards, use a smaller offset
	if card_count >= 7:
		offset = CARD_MIN_OFFSET
	
	var row: int = 0  # Current row index
	var x_position: float = 0  # Current x position within the row
	for i in range(card_count):
		var card: Node2D = _container.get_child(i)
		
		# Get the card's width
		var card_width: float = 80
		
		# If the card would overflow the screen width, move to the next row
		if x_position + card_width > screen_width:
			row += 1
			x_position = 0  # Reset x position for the new row
		
		# Calculate y position based on the row
		var y_position: float = row * (CARD_MIN_OFFSET)
		
		# Set the card's position
		card.position = Vector2(x_position, y_position)
		
		# Update x_position for the next card
		x_position +=  offset





# Signal handler for when the child order changes in the container.
# Repositions the cards after the order has changed.
func _on_CardContainer_child_order_changed() -> void:
	reposition_cards()

