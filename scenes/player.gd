extends Node2D

@export var basicWorldSpeed = 150
@onready var worldSpeed = basicWorldSpeed
var targetExtraSpeed: float
var actualExtraSpeed: float
var extraSpeedAcceleration: float
@onready var spineSprite: SpineSprite = $SpineSprite
var itemInUse

var bowDrawn: bool = false
var shieldOut: bool = false

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	actualExtraSpeed = lerp(actualExtraSpeed, targetExtraSpeed, extraSpeedAcceleration * delta)
	worldSpeed = basicWorldSpeed + actualExtraSpeed
	global_position.x += (worldSpeed) * delta
	ItemProcess(delta)

func _input(event):
	if itemInUse != null:
		match itemInUse.itemId:
			"bow":
				if event.is_action_pressed("left_click"):
					spineSprite.PlayWeaponAnimation("weapon/bowDraw", false, 4)
				if event.is_action_released("left_click"):
					if bowDrawn:
						if $SpineSprite/BowRay.is_colliding():
							$SpineSprite/BowRay.get_collider().get_parent().ReceiveHit(GetInventoryPower())
						itemInUse.DegradeItem()
						spineSprite.SetTargetMode(false)
						bowDrawn = false
						spineSprite.PlayWeaponAnimation("weapon/bowLoose", false, 4)
						itemInUse = null
						
					else:
						spineSprite.PlayWeaponAnimation("weapon/bowEquipped", false, 4, 0.25)
				if event.is_action_pressed("right_click"):
						spineSprite.SetTargetMode(false)
						spineSprite.PlayWeaponAnimation("weapon/bowUnequip", false, 4)
						itemInUse = null
			"shield":
				if event.is_action_pressed("right_click"):
						spineSprite.SetTargetMode(false)
						spineSprite.PlayWeaponAnimation("weapon/shieldUnequip", false, 4)
						itemInUse = null

func ItemProcess(delta):
	if itemInUse != null:
		match itemInUse.itemId:
			"shield":
				spineSprite.PlayMovementAnimation("movement/shieldRun", true, 1, 0.25, 0.5)
				SetMoveSpeed(0, 1)
				spineSprite.SetTargetMode(true)
				shieldOut = true
			"bow":
				spineSprite.PlayMovementAnimation("movement/groovyWalk", true, 1, 0.25)
				SetMoveSpeed(0, 5)
				spineSprite.SetTargetMode(true)
				shieldOut = false
			_:
				shieldOut = false
				ResetMoveSpeed()
	else:
		spineSprite.PlayWeaponAnimation("weapon/noWeapon", false, 4)
		shieldOut = false
		ResetMoveSpeed()
		spineSprite.SetTargetMode(false)

func UseItem(usedItem):
	itemInUse = usedItem
	match usedItem.itemId:
		"bow":
			spineSprite.PlayWeaponAnimation("weapon/bowEquip", false, 4)
		"shield":
			spineSprite.PlayWeaponAnimation("weapon/shieldEquip", false, 4)
		_:
			print("Item ID not defined in player script")

func GetInventoryPower():
	var inventory = itemInUse.get_parent()
	var itemPower = float(inventory.itemPower)
	var maxItemPower = float(inventory.inventorySlots.size())
	var powerRating: float = itemPower/maxItemPower
	print(powerRating)
	if powerRating >= 0.5:
		return 2
	else:
		return 1

func SetMoveSpeed(targetMoveSpeed, acceleration):
		var initialWorldSpeed = worldSpeed
		targetExtraSpeed = targetMoveSpeed
		extraSpeedAcceleration = acceleration

func ResetMoveSpeed():
	spineSprite.PlayMovementAnimation("movement/groovyWalk", true, 1, 0.25)
	targetExtraSpeed = 0
	extraSpeedAcceleration = 6

func UnequipItem():
	itemInUse = null
	spineSprite.PlayWeaponAnimation("weapon/noWeapon", false, 4)
	shieldOut = false
	ResetMoveSpeed()
	spineSprite.SetTargetMode(false)

func _on_spine_sprite_animation_completed(spine_sprite, animation_state, track_entry):
	match track_entry.get_animation().get_name():
		"weapon/bowDraw":
			bowDrawn = true

func _on_player_hit_area_area_entered(area):
	if shieldOut:
		$SpineSprite.ReceiveHit(true)
	else:
		$SpineSprite.ReceiveHit(false)
