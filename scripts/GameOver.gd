extends Node2D


# Reference to the label displaying the winner message
onready var _label: Label = $WinnerText


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_display_winner_message()


# Displays the winner message based on the current player.
func _display_winner_message() -> void:
	var current_player: int = GameManager.get_current_player()
	
	match current_player:
		GameManager.PLAYER_TURN.PLAYER:
			_label.text = "Congratulations, you have won!"
		GameManager.PLAYER_TURN.ENEMY:
			_label.text = "Oh no! You lost!"
		_:
			_label.text = "Error: Unknown game state."


# Handles input events for restarting or quitting the game.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		# Restart the game by emitting the start signal
		GameManager.emit_signal("signal_start_game")
	elif event.is_action_pressed("ui_cancel"):
		# Quit the game
		get_tree().quit()
