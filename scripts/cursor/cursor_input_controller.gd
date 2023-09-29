extends Control

@onready var spineSprite: SpineSprite = $"../PlayerCursor/SpineSprite"
@onready var playerCursor = $"../PlayerCursor"
@onready var pointerController = $"../PointerController"

var leftClick1: Vector2
var leftClick2: Vector2

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("right_click"):
		leftClick1 = playerCursor.global_position
		spineSprite.get_animation_state().set_animation("base/clickOn", false, 1).set_mix_duration(0)
		playerCursor.newVelocity = Vector2.ZERO
		pointerController.setSensitivity(0.2)
		$"../ClickOn".play()
	if event.is_action_released("right_click"):
		leftClick2 = playerCursor.global_position
		spineSprite.get_animation_state().set_animation("base/clickOff", false, 1).set_mix_duration(0)
		pointerController.resetSensitivity()
		$"../ClickOff".play()

	if event.is_action_pressed("left_click"):
		spineSprite.get_animation_state().set_animation("base/clickOn", false, 1).set_mix_duration(0)
		playerCursor.newVelocity = Vector2.ZERO
		pointerController.setSensitivity(0.6)
		$"../ClickOn".play()
	if event.is_action_released("left_click"):
		spineSprite.get_animation_state().set_animation("base/clickOff", false, 1).set_mix_duration(0)
		pointerController.resetSensitivity()
		$"../ClickOff".play()
