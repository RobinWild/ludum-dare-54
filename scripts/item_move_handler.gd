extends Node2D

var itemBeingMoved: Node2D
var itemMoveOffset: Vector2
var itemOriginalPos: Vector2

var itemPoint
var deletePoint
@onready var space_state = get_world_2d().direct_space_state
var physicsPoint: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
var itemResult
var deleteResult

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

func _input(event):
	if event.is_action_pressed("left_click"):
		if itemResult.size() > 0:
			itemBeingMoved = itemResult[0].collider.get_parent().get_parent()
			itemOriginalPos = itemBeingMoved.position
			itemMoveOffset = get_viewport().get_mouse_position() - itemBeingMoved.global_position
	
	if event.is_action_released("left_click"):
		if itemBeingMoved != null:
			if itemBeingMoved.CanSnap() and not itemBeingMoved.IsCollidingWithItem():
				itemBeingMoved.position.x = round(itemBeingMoved.position.x / 100) * 100
				itemBeingMoved.position.y = round(itemBeingMoved.position.y / 100) * 100
				$"../Inventory".AddItem(itemBeingMoved)
				itemBeingMoved = null
			elif not CheckForDeleteCollisions():
				$"../Inventory".RemoveItem(itemBeingMoved)
				itemBeingMoved.queue_free()
				itemBeingMoved = null
			else:
				itemBeingMoved.position = itemOriginalPos
				itemBeingMoved = null
