extends Node2D

class_name EnemyDeck

var _card_offset = 81

onready var _container = $CardContainer


func add_card(card: Card) -> void:
	card.position = global_position


func reposition_cards():
	for i in range(_container.get_child_count()):
		var card = _container.get_child(i)
		card.position = Vector2(i*_card_offset, 0)


func _on_CardContainer_child_order_changed():
	reposition_cards()
