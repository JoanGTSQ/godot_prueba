extends Node2D


# Reference to the label for displaying the winner message
onready var _label = $WinnerText


# Called when the node enters the scene tree for the first time
func _ready():
	var current_player: int = GameManager.get_current_player()
	# Display the appropriate message based on the current player's turn
	if current_player == GameManager.PLAYER_TURN.PLAYER:
		_label.text = "Congratulations, you have won!"
	elif current_player == GameManager.PLAYER_TURN.ENEMY:
		_label.text = "Oh no! You lost!"


# Handle input events, such as pressing "ui_accept" or "ui_cancel"
func _input(event):
	if event.is_action_pressed("ui_accept"):
		# Emit the signal to start the game
		GameManager.emit_signal("signal_start_game")
	elif event.is_action_pressed("ui_cancel"):
		# Quit the game when the cancel button is pressed
		get_tree().quit()
