extends SpineSprite

var tapTrack: SpineTrackEntry
@export var health: int = 3

var dead = false

func _ready():
	setAnimations()
	

func _process(delta):
	get_skeleton().set_to_setup_pose()

func setAnimations():
	tapTrack = get_animation_state().set_animation("empty", true, 1)

func GetTapped(damage):
	health -= damage
	if health > 0:
		if randi_range(0, 1) == 0:
			var trackEntry = get_animation_state().set_animation("tap", false, 2)
		else:
			var trackEntry = get_animation_state().set_animation("tap2", false, 2)
	elif health <= 0 and not dead:
		dead = true
		var trackEntry = get_animation_state().set_animation("smash", false, 2)
		$"../Smash".play()
		$"..".InstantiateItem()
		$"../Node2D".queue_free()
