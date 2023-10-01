extends Node2D

@export var possibleLoot:Array[PackedScene]

var itemId: String = "pot"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func GetTapped():
	$SpineSprite.GetTapped(1)

func ReceiveHit(damage):
	$SpineSprite.GetTapped()

func InstantiateItem():
	var randScene = randi_range(0, possibleLoot.size()-1)
	var newItem = possibleLoot[randScene].instantiate()
	add_child(newItem)
	newItem.global_position = global_position + Vector2(0,-100)
	newItem.rotation_degrees = 90 * (randi_range(0, 3))
