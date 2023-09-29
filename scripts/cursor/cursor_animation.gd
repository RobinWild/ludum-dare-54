extends SpineSprite

var idleTrack: SpineTrackEntry
var rightClickOverride: bool

func _ready():
	setAnimations()
	

func _process(delta):
	get_skeleton().set_to_setup_pose()

func setAnimations():
	idleTrack = get_animation_state().set_animation("base/breathe")
	get_animation_state().set_animation("empty", true, 1).set_mix_duration(0.5)
