extends Area2D

var entered: bool = false
@onready var itemMoveHandler = $"../../../ItemMoveHandler"

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass

func _input(event):
	if entered:
		if event.is_action_pressed("left_click"):
			print($"../..".name)

func _on_mouse_entered():
	entered = true
	itemMoveHandler.AttemptHover($"../..")

func _on_mouse_exited():
	itemMoveHandler.Unhover($"../..")
	entered = false
