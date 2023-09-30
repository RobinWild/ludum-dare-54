extends Node2D

@export var worldSpeed: float = 100
@export var decorationScenes:Array[PackedScene]

func _ready():
	SpawnDecoration()
	pass # Replace with function body.

func _process(delta):
	global_position.x += -worldSpeed * delta

func _physics_process(delta):
	if not $"../../RayCast2D".is_colliding():
		SpawnDecoration()

func SpawnDecoration():
	var randScene = randi_range(0, decorationScenes.size()-1)
	var newWorldScene = decorationScenes[randScene].instantiate()
	add_child(newWorldScene)
	newWorldScene.global_position = $"../../RayCast2D".global_position + Vector2(newWorldScene.length, 0)
