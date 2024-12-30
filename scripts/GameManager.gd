extends Node2D

# Constants representing players.
enum PLAYER_TURN { 
	PLAYER, 
	ENEMY
}


# Initial number of cards in each player's hand.
const INITIAL_HAND_SIZE : int = 7
const ENEMY_WAIT_TIME : float = 1.5

# Current player's turn.
var _player_turn : int = 0
var _player_hands : Array = []
var _player_deck : Node = null
var _player_deck_container : Node = null
var _enemy_deck : Node = null
var _enemy_deck_container : Node = null
var _player_said_uno : bool = false

# Signals for game events.
signal signal_turn_changed(player)
signal signal_card_played(player, card)
signal signal_special_card_played(player, card)
signal signal_play_card(player, card)
signal signal_draw_card(player)
signal signal_start_game()
signal signal_say_uno(player)


# Initializes the scene and connects signals.
func _ready() -> void:
	_connect_signals()


# Deals a specified number of cards to each player.
# @param num_cards Number of cards to deal.
func _deal_cards(num_cards : int) -> void:
	for _i in range(num_cards):
		for i in range(_player_hands.size()):
			var hand : Array = _player_hands[i]
			if DeckManager.deck.size() > 0:
				var card : Card = DeckManager.draw()
				hand.append(card)
				_move_cards(i, card)


# Gets the current player.
# @return int The current player.
func get_current_player() -> int:
	return _player_turn

# --- Private Methods ---

func _check_uno_rule(player : int) -> void:
	if _player_hands[player].size() == 1 and not _player_said_uno:
		for _i in range(2):
			emit_signal("signal_draw_card", player, true)


# Applies the effects of a special card.
# @param player The player who played the special card.
func _apply_special_card(player : int, card : Card) -> bool:
	var other_player : int = (player + 1) % 2
	var card_value : String = card.get_value()
	if card_value == "+2":
		for _i in range(2):
			emit_signal("signal_draw_card", other_player, true)
	elif card_value == "SKIP":
		return false
	elif card_value == "SWAP":
		_swap_decks()
	return true


func _swap_decks() -> void:
	# Swap the hands in memory
	var temp_hand = _player_hands[PLAYER_TURN.PLAYER]
	_player_hands[PLAYER_TURN.PLAYER] = _player_hands[PLAYER_TURN.ENEMY]
	_player_hands[PLAYER_TURN.ENEMY] = temp_hand

	# Move the cards visually to the appropriate containers
	for card in _player_hands[PLAYER_TURN.PLAYER]:
		if card.get_parent():
			card.get_parent().remove_child(card)
		_player_deck_container.add_child(card)
		card.set_filter(false) 
		
	for card in _player_hands[PLAYER_TURN.ENEMY]:
		if card.get_parent():
			card.get_parent().remove_child(card)
		_enemy_deck_container.add_child(card)
		card.set_filter(true)  
	
	print("Decks have been swapped!")


# Checks if it's the specified player's turn.
# @param player The player to check.
# @return bool True if it is the player's turn.
func _is_player_turn(player : int) -> bool:
	return _player_turn == player


# Checks if the game has ended.
# @return bool True if the game has ended.
func _check_game_end() -> bool:
	for i in range(_player_hands.size()):
		if _player_hands[i].size() == 0:
			_end_game()
			return true
	return false

# Método para el jugador decir "UNO"
func _on_signal_say_uno(player : int) -> void:
	if _player_hands[player].size() == 2:
		_player_said_uno = true


# Moves a card to the specified player's deck container.
# @param player The player receiving the card.
# @param card The card to move.
func _move_cards(player : int, card : Card) -> void:
	if card.get_parent():
		card.get_parent().remove_child(card)
	if player == PLAYER_TURN.PLAYER:
		_player_deck_container.add_child(card)
		_player_deck.reposition_cards()
	elif player == PLAYER_TURN.ENEMY:
		_enemy_deck_container.add_child(card)
		card.set_filter(true)
		_enemy_deck.reposition_cards()


# Executes the AI player's turn.
func _ai_play() -> void:
	if _player_turn == PLAYER_TURN.ENEMY:
		for card in _player_hands[PLAYER_TURN.ENEMY]:
			if DeckManager.is_valid_card(card):
				var r_number = randi() % 99
				if r_number % 2:
					emit_signal("signal_say_uno", PLAYER_TURN.ENEMY)
				emit_signal("signal_play_card", PLAYER_TURN.ENEMY, card)
				return
		emit_signal("signal_draw_card", PLAYER_TURN.ENEMY, false)


# Changes the turn to the next player.
func _change_turn(is_special_card : bool) -> void:
	if not is_special_card:
		_check_uno_rule(_player_turn)
		_player_said_uno = false
		_player_turn = (_player_turn + 1) % 2
	emit_signal("signal_turn_changed")


# Ends the game and cleans up resources.
func _end_game() -> void:
	DeckManager.destroy()
	get_tree().change_scene("res://scenes/GameOverScene.tscn")
	print("Game ended.")


# Connects signals to their respective methods.
func _connect_signals() -> void:
	connect("signal_start_game", self, "_on_signal_start_game")
	connect("signal_turn_changed", self, "_on_signal_turn_changed")
	connect("signal_special_card_played", self, "_on_signal_special_card_played")
	connect("signal_card_played", self, "_on_signal_card_played")
	connect("signal_draw_card", self, "_on_signal_draw_card")
	connect("signal_play_card", self, "_on_signal_play_card")
	connect("signal_say_uno", self, "_on_signal_say_uno")


# Handles the event of the turn changing.
func _on_signal_turn_changed() -> void:
	var board : Node = get_tree().root.get_node("Board")
	board.update_turn_label()
	board.update_main_card()
	if _player_turn == PLAYER_TURN.ENEMY:
		yield(get_tree().create_timer(ENEMY_WAIT_TIME), "timeout")
		_ai_play()


# Handles the event of a card being played.
# @param card The card that was played.
func _on_signal_card_played() -> void:
	_change_turn(false)

func _on_signal_special_card_played() -> void:
	_change_turn(true)

# Attempts to play a card for a player.
# @param player The player playing the card.
# @param card The card to play.
# @return bool True if the card was successfully played.
func _on_signal_play_card(player : int, card : Card) -> bool:
	if DeckManager.is_valid_card(card) and _is_player_turn(player):
		_player_hands[player].erase(card)
		DeckManager.discard_card(card)
		if _check_game_end():
			return true
		if card.is_special_card():
			if not _apply_special_card(player, card):
				emit_signal("signal_special_card_played")
				return true
		emit_signal("signal_card_played")
		return true
	return false


# Draws a card for a player.
# @param player The player drawing the card.
# @param special_card Whether the card is drawn due to a special effect.
func _on_signal_draw_card(player : int, special_card : bool) -> void:
	if player == _player_turn or special_card:
		var card : Card = DeckManager.draw()
		_player_hands[player].append(card)
		_move_cards(player, card)
	if not special_card:
		_change_turn(false)


# Starts the game and initializes the decks and hands.
func _on_signal_start_game() -> void:
	get_tree().change_scene("res://scenes/Board.tscn")

	_player_turn = PLAYER_TURN.PLAYER

	DeckManager.set_up()
	print("Game started.")

	# Wait until the scene is ready.
	for _i in range(2):
		yield(get_tree(), "idle_frame")

	_player_deck = get_tree().root.get_node("Board/PlayerDeck")
	_player_deck_container = _player_deck.get_node("CardContainer")
	_enemy_deck = get_tree().root.get_node("Board/EnemyDeck")
	_enemy_deck_container = _enemy_deck.get_node("CardContainer")

	_player_hands = [[], []]

	_deal_cards(INITIAL_HAND_SIZE)
