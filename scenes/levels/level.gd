extends Node2D

@export var transparentBackground: bool
var mainMenuOpen: bool = true
var miniMenuOpen: bool = false

func _ready():
	$MenuMini.hide()
	$"MenuMain".show()
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
	mainMenuOpen = false
	get_tree().paused = false
	$"MenuMain".hide()
	$MenuButton.show()

func MainMenu():
	ToggleMiniMenu()
	get_tree().paused = true
	$"MenuMain".show()
	$MenuButton.hide()

func ToggleMiniMenu():
	if not mainMenuOpen:
		if miniMenuOpen:
			get_tree().paused = false
			miniMenuOpen = false
			$MenuMini.hide()
		else:
			get_tree().paused = true
			miniMenuOpen = true
			$MenuMini.show()

func _input(event):
	if event.is_action_pressed("menu"):
		ToggleMiniMenu()
