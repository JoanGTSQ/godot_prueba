extends Node2D

class_name Card

# Private variables
var _special_card : bool = false

# Onready variables
onready var _card : Node2D = $Card
onready var _background : ColorRect = $Card/Background
onready var _value : Label = $Card/Value
onready var _animation_player : AnimationPlayer = $Card/AnimationPlayer
onready var _filter : Control = $Card/Filter


# Resets the card's position for proper animation alignment.
func reset_position() -> void:
	_card.position = Vector2(0,0)


# Updates the card's color and value.
# @param new_color The new color of the card.
# @param new_value The new value of the card.
# @param special_card Whether the card is special.
func set_up(new_color : Color, new_value : String, special_card : bool) -> void:
	_background.color = new_color
	_value.text = new_value
	_special_card = special_card


# Event handler for mouse input on the card.
# @param event Input event to handle.
func _on_center_container_gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and !self.is_in_group("main_card") and !_filter.visible:
		reset_position()
		# Emit the signal to play the card.
		GameManager.emit_signal("signal_play_card", GameManager.PLAYER_TURN.PLAYER, self)


# Event handler for when the mouse enters the card area.
func _on_center_container_mouse_entered() -> void:
	if !self.is_in_group("main_card"):
		_animation_player.play("hover_in")


# Event handler for when the mouse exits the card area.
func _on_center_container_mouse_exited() -> void:
	if !self.is_in_group("main_card"):
		_animation_player.play("hover_out")


# Event handler for when the card is removed from the scene.
func _on_card_container_tree_exiting() -> void:
	_animation_player.stop(false)


# Sets the visibility of the card's filter.
# @param filter_visible If true, activates the filter.
func set_filter(filter_visible : bool) -> void:
	_filter.visible = filter_visible


# Returns the color of the card's background.
# @return The color of the card's background.
func get_color() -> Color:
	return _background.color


# Returns the value text of the card.
# @return The value of the card.
func get_value() -> String:
	return _value.text


# Returns whether the card is special.
# @return True if the card is special, otherwise false.
func is_special_card() -> bool:
	return _special_card
