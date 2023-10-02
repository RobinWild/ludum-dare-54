extends Node2D

@export var basicWorldSpeed = 150
@onready var worldSpeed = basicWorldSpeed
@export var maxHealth: int = 1
@onready var currentHealth: int = maxHealth
var targetExtraSpeed: float
var actualExtraSpeed: float
var difficulty: float = 0
var extraSpeedAcceleration: float
@onready var spineSprite: SpineSprite = $SpineSprite
var itemInUse

var bowDrawn: bool = false
var swordReady: bool = false
var shieldOut: bool = false
var waitingForSwordSwing: bool = false

@onready var inventory = $"../../../InventoryRoot/Inventory"

var inventoryPower: int

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	actualExtraSpeed = lerp(actualExtraSpeed, targetExtraSpeed, extraSpeedAcceleration * delta)
	if currentHealth > 0:
		worldSpeed = basicWorldSpeed + actualExtraSpeed + difficulty
	else:
		worldSpeed = 0
	global_position.x += (worldSpeed) * delta
	ItemProcess(delta)
	difficulty += 1.5 * delta

func _input(event):
	if itemInUse != null and not $"../../../ItemMoveHandler".CheckForDeleteCollisions():
		match itemInUse.itemId:
			"bow":
				if event.is_action_pressed("left_click"):
					spineSprite.PlayWeaponAnimation("weapon/bowDraw", false, 4)
				if event.is_action_released("left_click"):
					if bowDrawn:
						if $SpineSprite/BowRay.is_colliding():
							UpdateInventoryPower()
							$SpineSprite/BowRay.get_collider().get_parent().ReceiveHit(inventoryPower)
						itemInUse.DegradeItem()
						spineSprite.SetTargetMode(false)
						bowDrawn = false
						spineSprite.PlayWeaponAnimation("weapon/bowLoose", false, 4)
						$BowLoose.play()
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
			"sword":
				if event.is_action_pressed("left_click"):
					UpdateInventoryPower()
					waitingForSwordSwing = true
					$SwordSwing.play()
					spineSprite.PlayWeaponAnimation("weapon/swordSwing", false, 4)
					$SwordArea/SwordCollider.disabled = false
#					itemInUse.DegradeItem()
				if event.is_action_pressed("right_click"):
						spineSprite.SetTargetMode(false)
						spineSprite.PlayWeaponAnimation("weapon/swordUnequip", false, 4)
						itemInUse = null

func ItemProcess(delta):
	if itemInUse != null:
		match itemInUse.itemId:
			"shield":
				spineSprite.PlayMovementAnimation("movement/shieldRun", true, 1, 0.25, 0.5)
				SetMoveSpeed(0, 1)
				spineSprite.SetTargetMode(false)
				shieldOut = true
			"bow":
				spineSprite.PlayMovementAnimation("WALK", true, 1, 0.25)
				SetMoveSpeed(0, 5)
				spineSprite.SetTargetMode(true)
				shieldOut = false
			"sword":
				spineSprite.PlayMovementAnimation("WALK", true, 1, 0.25)
				SetMoveSpeed(0, 5)
				spineSprite.SetTargetMode(false)
				shieldOut = false
			_:
				shieldOut = false
				ResetMoveSpeed()
	else:
		if not waitingForSwordSwing:
			spineSprite.PlayWeaponAnimation("weapon/noWeapon", false, 4)
		shieldOut = false
		ResetMoveSpeed()
		spineSprite.SetTargetMode(false)

func UseItem(usedItem):
	if usedItem != null:
		itemInUse = usedItem
		match usedItem.itemId:
			"bow":
				spineSprite.PlayWeaponAnimation("weapon/bowEquip", false, 4)
				$PickUpItem.play()
			"shield":
				spineSprite.PlayWeaponAnimation("weapon/shieldEquip", false, 4)
				$PickUpItem.play()
			"sword":
				spineSprite.PlayWeaponAnimation("weapon/swordEquip", false, 4)
				$PickUpItem.play()
			_:
				print("Item ID not defined in player script")

func UpdateInventoryPower():
	var itemPower = float(inventory.itemPower)
	var maxItemPower = float(inventory.inventorySlots.size())
	var powerRating: float = itemPower/maxItemPower
	if powerRating >= 0.5:
		inventoryPower = 2
	else:
		inventoryPower =  1

func SetMoveSpeed(targetMoveSpeed, acceleration):
		var initialWorldSpeed = worldSpeed
		targetExtraSpeed = targetMoveSpeed
		extraSpeedAcceleration = acceleration

func ResetMoveSpeed():
	spineSprite.PlayMovementAnimation("WALK", true, 1, 0.25)
	targetExtraSpeed = 0
	extraSpeedAcceleration = 6

func UnequipItem():
	itemInUse = null
	spineSprite.PlayWeaponAnimation("weapon/noWeapon", false, 4)
	shieldOut = false
	ResetMoveSpeed()
	spineSprite.SetTargetMode(false)
	$"../../../ItemMoveHandler/BowPlace".play()

func _on_spine_sprite_animation_completed(spine_sprite, animation_state, track_entry):
	match track_entry.get_animation().get_name():
		"weapon/bowDraw":
			bowDrawn = true
		"weapon/swordWindup":
			swordReady = true
		"weapon/swordSwing":
			$SwordArea/SwordCollider.disabled = true
			itemInUse = null
			waitingForSwordSwing = false

func _on_spine_sprite_animation_interrupted(spine_sprite, animation_state, track_entry):
	match track_entry.get_animation().get_name():
		"weapon/bowDraw":
			bowDrawn = true
		"weapon/swordWindup":
			swordReady = true
		"weapon/swordSwing":
			$SwordArea/SwordCollider.disabled = true
			itemInUse = null
			waitingForSwordSwing = false

func _on_player_hit_area_area_entered(area):
	if shieldOut:
		$HitShield.play()
		UpdateInventoryPower()
		$SpineSprite.ReceiveHit(true)
		if inventoryPower == 2:
			itemInUse.DegradeItem(1)
		else:
			itemInUse.DegradeItem(2)
	else:
		currentHealth -= 1
		if currentHealth <= 0:
			$HitDie.play()
			$"../../../GameOverScreen/GameOverAnimationPlayer".play("game_over")
			spineSprite.PlayWeaponAnimation("hit/die", false, 2)
			$PlayerHitArea/PlayerCollider.disabled = true
		else:
			$HitDie.play()
			$SpineSprite.ReceiveHit(false)


func _on_sword_area_area_entered(area):
	for i in $SwordArea.get_overlapping_areas():
		print(i.get_parent().name)
		i.get_parent().ReceiveHit(inventoryPower)


