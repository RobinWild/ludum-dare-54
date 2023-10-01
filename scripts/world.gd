extends Node2D

@onready var worldSpeed: float
@export var decorationScenes:Array[PackedScene]
@export var potScenes:Array[PackedScene]
@export var enemyScenes:Array[PackedScene]
@export var enemySpawnTimerMin: float = 2
@export var enemySpawnTimerMax: float = 10

func _ready():
	SpawnDecoration()
	pass # Replace with function body.

func _process(delta):
	worldSpeed = $Player.worldSpeed
	global_position.x += -worldSpeed * delta

func _physics_process(delta):
	if not $"../../RayCast2D".is_colliding():
		SpawnDecoration()

func SpawnDecoration():
	var randScene = randi_range(0, decorationScenes.size()-1)
	var newWorldScene = decorationScenes[randScene].instantiate()
	add_child(newWorldScene)
	newWorldScene.global_position = $"../../RayCast2D".global_position + Vector2(newWorldScene.length, 0)

func SpawnEnemy():
	$Timer.wait_time = randf_range(enemySpawnTimerMin, enemySpawnTimerMax)
	
	var randScene = randi_range(0, enemyScenes.size()-1)
	var newEnemyScene = enemyScenes[randScene].instantiate()
	add_child(newEnemyScene)
	newEnemyScene.global_position = $"../../RayCast2D".global_position
	
func SpawnPot():
	var randScene = randi_range(0, potScenes.size()-1)
	var newPotScene = potScenes[randScene].instantiate()
	add_child(newPotScene)
	newPotScene.global_position = $"../../RayCast2D".global_position + Vector2(500, 0)

func _on_timer_timeout():
	print("timer")
	SpawnEnemy()
	SpawnPot()
