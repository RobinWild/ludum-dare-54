extends Node2D

var itemBeingMoved: Node2D
var itemMoveOffset: Vector2
var itemOriginalPos: Vector2

var itemPoint
var deletePoint
var equipPoint
@onready var space_state = get_world_2d().direct_space_state
var physicsPoint: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
var itemResult
var deleteResult
var equipResult

func _ready():
	pass # Replace with function body.

func _process(delta):
	if itemBeingMoved != null:
		itemBeingMoved.global_position = get_viewport().get_mouse_position() - itemMoveOffset

func _physics_process(delta):
	CheckForItemCursorCollisions()

func CheckForItemCursorCollisions():
	itemPoint = get_viewport().get_mouse_position()
	physicsPoint.position = itemPoint
	physicsPoint.collide_with_areas = true
	physicsPoint.collision_mask = 2
	itemResult = space_state.intersect_point(physicsPoint, 1)
	
func CheckForDeleteCollisions():
	deletePoint = get_viewport().get_mouse_position()
	physicsPoint.position = deletePoint
	physicsPoint.collide_with_areas = true
	physicsPoint.collision_mask = 16
	deleteResult = space_state.intersect_point(physicsPoint, 1)
	if deleteResult.is_empty():
		return false
	else:
		return true

func CheckForEquipCollisions():
	equipPoint = get_viewport().get_mouse_position()
	physicsPoint.position = equipPoint
	physicsPoint.collide_with_areas = true
	physicsPoint.collision_mask = 256
	equipResult = space_state.intersect_point(physicsPoint, 1)
	if equipResult.is_empty():
		return false
	else:
		return true

func _input(event):
	if event.is_action_pressed("left_click"):
		if itemResult.size() > 0:
			if itemResult[0].collider.get_parent().get_parent().itemId != "pot":
				itemBeingMoved = itemResult[0].collider.get_parent().get_parent()
				itemOriginalPos = itemBeingMoved.position
				itemMoveOffset = get_viewport().get_mouse_position() - itemBeingMoved.global_position
			else:
				itemResult[0].collider.get_parent().get_parent().GetTapped()
	
	if event.is_action_released("left_click"):
		if itemBeingMoved != null:
			if itemBeingMoved.CanSnap() and not itemBeingMoved.IsCollidingWithItem(): # snap to inventory
				itemBeingMoved.isInInventory = true
				itemBeingMoved.reparent($"../InventoryRoot/Inventory")
				itemBeingMoved.position.x = round(itemBeingMoved.position.x / 100) * 100
				itemBeingMoved.position.y = round(itemBeingMoved.position.y / 100) * 100
				$"../InventoryRoot/Inventory".AddItem(itemBeingMoved)
				itemBeingMoved = null
			elif CheckForEquipCollisions() and itemBeingMoved.isInInventory: # equip
				$"../WorldRoot/World/Player".UseItem(itemBeingMoved)
				itemBeingMoved.position = itemOriginalPos # move back to original position
				itemBeingMoved = null
			elif not CheckForDeleteCollisions() and itemBeingMoved.isInInventory: # delete object
				$"../InventoryRoot/Inventory".RemoveItem(itemBeingMoved)
				itemBeingMoved.queue_free()
				itemBeingMoved = null
			else:
				itemBeingMoved.position = itemOriginalPos # move back to original position
				itemBeingMoved = null
	
	if event.is_action_pressed("right_click") and itemBeingMoved == null:
		if itemResult.size() > 0:
			var usedItem = itemResult[0].collider.get_parent().get_parent()
			if usedItem.itemId != "pot":
				if usedItem.isInInventory:
					$"../WorldRoot/World/Player".UseItem(usedItem)
