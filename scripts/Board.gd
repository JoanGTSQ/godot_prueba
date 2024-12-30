extends Node2D

# Reference to the main card node
onready var _main_card = $Card
onready var _turn_label = $TurnLabel
onready var _player_deck = $PlayerDeck
onready var _say_uno_button = $SayUno

# Updates the main card on the board
func update_main_card() -> void:
	# Get the current card from the "main_card" group
	var current_card = get_tree().get_nodes_in_group("main_card").back()
	var new_card: Card = DeckManager.get_current_card()
	if new_card == current_card:
		return
	
	_add_card_to_board(new_card)
	
	if get_tree().get_nodes_in_group("main_card").size() >= 1:
		# Remove the current card from the group and parent node
		current_card.remove_from_group("main_card")
		current_card.get_parent().remove_child(current_card)
	else:
		new_card = DeckManager.get_current_card()
		_add_card_to_board(new_card)
	

func _enable_say_uno_button() -> void:
	if _get_players_card_count() <= 2:
		_say_uno_button.visible = true
	else:
		_say_uno_button.visible = false

func _get_players_card_count() -> int:
	return _player_deck.get_node("CardContainer").get_child_count()

func _add_card_to_board(card : Card) -> void:
	# If the new card already has a parent, remove it from there
	if card.get_parent():
		card.get_parent().remove_child(card)
			
	# Add the new card to the node and set its position
	add_child(card)
	card.position = _main_card.position
	card.add_to_group("main_card")
	
	
# Update the TurnLabel text
func update_turn_label() -> void:
	if GameManager.get_current_player() == GameManager.PLAYER_TURN.PLAYER:
		_turn_label.text = "PLAYER TURN"
	else:
		_turn_label.text = "ENEMY TURN"
	_enable_say_uno_button()


# Event triggered when the button is pressed
func _on_DrawCard_Button_pressed() -> void:
	if GameManager.get_current_player() == GameManager.PLAYER_TURN.PLAYER:
		GameManager.emit_signal("signal_draw_card", GameManager.PLAYER_TURN.PLAYER, false)

func _on_say_uno_button_pressed() -> void:
	GameManager.emit_signal("signal_say_uno", GameManager.PLAYER_TURN.PLAYER)
	
# Set up the main card when the board is ready
func _on_Board_ready() -> void:
	update_main_card()
