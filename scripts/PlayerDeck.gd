extends Node2D

class_name PlayerDeck

var _card_offset = 80
var _card_offset_min = 70

onready var _container = $CardContainer

func add_card(card: Card) -> void:
	card.position = global_position

func reposition_cards():
	var cardCount = _container.get_child_count()
	var offset = _card_offset
	if cardCount >= 7:
		offset = _card_offset_min
	for i in range(_container.get_child_count()):
		var card = _container.get_child(i)
		card.position = Vector2(i*offset, 0)


func _on_CardContainer_child_order_changed():
	reposition_cards()
