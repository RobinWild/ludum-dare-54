extends Node

@export var defaultSensitivity: float = 1
@onready var sensitivity: float = defaultSensitivity

var mouseDelta: Vector2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func _input(event):
	# Check if the event is of type InputEventMouseMotion
	if event is InputEventMouseMotion:
		mouseDelta += event.relative * sensitivity

func setSensitivity(newSensitivityScalar: float):
	sensitivity = defaultSensitivity * newSensitivityScalar

func resetSensitivity():
	sensitivity = defaultSensitivity
