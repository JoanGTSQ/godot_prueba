extends Node2D

class_name Card

var _special_card : bool = false
# Nodes for the card's components
onready var _background = $Background
onready var _value = $Value
onready var _animation_player = $AnimationPlayer
onready var _filter = $Filter


# Updates the card's color and value
func set_up(new_color: Color, new_value: String, special_card : bool) -> void:
	_background.color = new_color
	_value.text = new_value
	_special_card = special_card


# Event handler for mouse input on the card
func _on_CenterContainer_gui_input(event):
	if event is InputEventMouseButton and event.pressed and !self.is_in_group("main_card") and !_filter.visible:
		# Emit the signal to play the card
		GameManager.emit_signal("signal_play_card", GameManager.PLAYER_TURN.PLAYER, self)


# Event handler for when the mouse enters the card area
func _on_CenterContainer_mouse_entered():
	if !self.is_in_group("main_card"):
		_animation_player.play("hover_in")


# Event handler for when the mouse exits the card area
func _on_CenterContainer_mouse_exited():
	if !self.is_in_group("main_card"):
		_animation_player.play("hover_out")


# Event handler for when the card is removed from the scene
func _on_Card_tree_exiting():
	_animation_player.stop(false)


# Sets the visibility of the card's filter
func set_filter(filter_visible: bool) -> void:
	_filter.visible = filter_visible


# Returns the color of the card's background
func get_color() -> Color:
	return _background.color


# Returns the value text of the card
func get_value() -> String:
	return _value.text

func is_special_card() -> bool:
	return _special_card
