extends Node2D

var snapColliders = []
var itemColliders = []
var currentPos: Vector2 = Vector2(1920,1080)
var itemPower: int
var isInInventory: bool = false

func _ready():
	GetSnapColliders()
	GetItemColliders()

func _process(delta):
	MoveSprite(delta)
	pass

func _physics_process(delta):
	pass

func GetSnapColliders():
	for i in self.get_children():
		for i2 in i.get_children():
			if i2 is Area2D:
				if i2.collision_mask == 1:
					snapColliders.append(i2)
					itemPower += 1

func GetItemColliders():
	for i in self.get_children():
		for i2 in i.get_children():
			if i2 is Area2D:
				if i2.collision_mask == 8:
					itemColliders.append(i2)

func CanSnap():
	# Check that every snap collider is overlapping
	for i in snapColliders:
		if not i.has_overlapping_areas():
			return false
	return true

func IsCollidingWithItem():
	for i in itemColliders:
		if i.has_overlapping_areas():
			return true
	return false

func MoveSprite(delta):
	var targetPos = self.global_position
	
	currentPos = lerp(currentPos, targetPos, 30 * delta)
	
	$ItemSprite.global_position = currentPos
