extends Node2D

@export var transparentBackground: bool
var mainMenuOpen: bool = true
var miniMenuOpen: bool = false

@export var packedGameScene: PackedScene
var gameScene

func _ready():
	$MenuMini.hide()
	$MenuButton.hide()
	MakeScreenTransparent()

func _process(delta):
	pass

func MakeScreenTransparent():
	if transparentBackground:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true, 0)
		get_tree().get_root().set_transparent_background(true)

func QuitGame():
	get_tree().quit()

func OpenTwitter():
	OS.shell_open("https://twitter.com/Robbobin")

func StartGame():
	gameScene = packedGameScene.instantiate()
	add_child(gameScene)
	$MenuMain.current_animation = "hide"
	mainMenuOpen = false
	get_tree().paused = false
	$MenuButton.show()
	$MenuMain/SfxGong.play()

func MainMenu():
	if gameScene != null:
		gameScene.queue_free()
		
	$MenuMain.current_animation = "show"
	ToggleMiniMenu()
	get_tree().paused = true
#	$"MenuMain".show()
	$MenuButton.hide()

func ToggleMiniMenu():
	if not mainMenuOpen:
		if miniMenuOpen:
			get_tree().paused = false
			miniMenuOpen = false
			$MenuMini.hide()
		else:
			$"Game/WorldRoot".position = Vector2(-1436,0)
			$"Game/InventoryRoot".position = Vector2(0,0)
			get_tree().paused = true
			miniMenuOpen = true
			$MenuMini.show()

func _input(event):
	if event.is_action_pressed("menu"):
		ToggleMiniMenu()
