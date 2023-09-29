extends Node2D

# VARIABLES
@export var debugMode: bool = false
@export var defaultScale: float = 0.25

var velocity: Vector2 = Vector2.ZERO
var newVelocity: Vector2 = Vector2.ZERO
var extraMomentum: float = 1

@onready var pointerPosition: Vector2 = get_viewport().size / 2
@onready var momentumIK: Node2D = $"../MomentumIK"
@onready var spineSprite: SpineSprite = $SpineSprite
@onready var ikBone: SpineBoneNode = $SpineSprite/ikTarget
@onready var pointerController = $"../PointerController"
@onready var cursor = $"../Cursor"

func _ready():
	global_position = get_viewport().size / 2
	scale = Vector2.ONE * defaultScale

func _process(delta):
	setPlayerScale()
	debugVisibility()
	updatePointerPosition()
	setIkTargetPosition()

func _physics_process(delta):
	pass

func setPlayerScale():
	if Input.is_action_just_pressed("up"):
		scale += Vector2.ONE * 0.05
	if Input.is_action_just_pressed("down"):
		scale -= Vector2.ONE * 0.05

func debugVisibility():
	if Input.is_action_just_pressed("debug"):
		debugMode = !debugMode

func updatePointerPosition():
	global_position = get_viewport().get_mouse_position()

func setIkTargetPosition():
	ikBone.global_position = momentumIK.global_position

func applyForce(newForce: Vector2):
	newVelocity += newForce
