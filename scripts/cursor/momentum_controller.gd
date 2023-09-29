extends Node2D

# CONSTANTS

# VARIABLES
@export var moveSpeed: float = 800
@export var acceleration: float = 1
@export var maxDistance: float = 200
@export var decelerationDistance: float = 200
@onready var target: Node2D = $"../PlayerCursor"
@onready var initialCenterOfMass: Vector2 = position
@onready var centerOfMass: Vector2 = initialCenterOfMass * target.scale
@onready var targetPosition: Vector2 = get_viewport().size / 2
var velocity: Vector2 = Vector2.ZERO

# DEBUG
@onready var debugScale: Vector2 = scale

func _ready():
	global_position = get_viewport().size / 2

func _process(delta):
	setScaleValues()
	debugVisibility()
	clampYPosition()
	clampToCircleRadius($"../PlayerCursor".global_position, maxDistance)
	updatePointerPosition()
	calculateVelocity(delta)

func _physics_process(delta):
	pass

func setScaleValues():
	centerOfMass = initialCenterOfMass * target.scale

func debugVisibility():
	if not target.debugMode:
		global_scale = Vector2.ZERO
	else:
		global_scale = debugScale

func updatePointerPosition():
	targetPosition = target.global_position + centerOfMass
	var toPosition = Vector2(targetPosition - target.global_position)
	var distanceToTarget = toPosition.length()
	if distanceToTarget < centerOfMass.y * 0.5:
		toPosition = toPosition.normalized * centerOfMass.y * 0.5
		targetPosition = toPosition

func calculateVelocity(delta):
	var normalizedMouseVector = (global_position - targetPosition).normalized()
	var distanceFromPointer = clamp((targetPosition - global_position).length(), 0, decelerationDistance) / decelerationDistance * 2
	var targetVelocity = -normalizedMouseVector

	velocity = velocity.lerp(targetVelocity * distanceFromPointer, acceleration * target.extraMomentum)
	global_position += velocity * moveSpeed * delta

func clampYPosition():
	global_position.y = target.global_position.y + centerOfMass.y

func clampToCircleRadius(center: Vector2, radius: float):
	# Calculate the vector from the center of the circle to the current global position
	var offset = global_position - center

	# Calculate the distance from the center of the circle to the current global position
	var distance = offset.length()

	# If the distance is greater than the radius, clamp it to the radius
	if distance > radius:
		offset = offset.normalized() * radius

		# Set the global position to the clamped position
		global_position = center + offset
