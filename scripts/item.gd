extends Node2D

@export var itemId: String
@export var itemDurability: int = 2
var snapColliders = []
var itemColliders = []
var currentPos: Vector2 = Vector2(1920,1080)
var itemPower: int
var isInInventory: bool = false
var isInUse: bool = false

@onready var spriteOffset: Vector2 = $ItemSprite.position

func _ready():
	GetSnapColliders()
	GetItemColliders()

func _process(delta):
	MoveSprite(delta)
	if $"../".name == "Inventory":
		if $"../../../WorldRoot/World/Player".itemInUse == self:
			isInUse = true
		else:
			isInUse = false
	
	if isInUse:
		$ItemSprite/SelectedSprite.set_modulate(Color(1,1,1,1))
	else:
		$ItemSprite/SelectedSprite.set_modulate(Color(1,1,1,0))

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
	var targetPos = self.global_position + spriteOffset.rotated(rotation)
	
	currentPos = lerp(currentPos, targetPos, 30 * delta)
	
	$ItemSprite.global_position = currentPos

func DegradeItem(damage: int = 1):
	itemDurability -= damage
	if itemDurability == damage:
		$ItemSprite/DegradedSprite.set_modulate(Color(1,1,1,1))
	if itemDurability <= 0:
		$"..".RemoveItem(self)
		queue_free()
