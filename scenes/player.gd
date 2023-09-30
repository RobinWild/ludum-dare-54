extends Node2D

@onready var worldSpeed = $"..".worldSpeed

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x += worldSpeed * delta
