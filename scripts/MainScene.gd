extends Node2D

# Called when the button is pressed
func _on_start_game_button_pressed() -> void:
	# Emit the signal to start the game
	GameManager.emit_signal("signal_start_game")
