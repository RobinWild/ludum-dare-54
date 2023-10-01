extends SpineSprite

var idleTrack: SpineTrackEntry

func _ready():
	setAnimations()

func _process(delta):
	get_skeleton().set_to_setup_pose()

func setAnimations():
	idleTrack = get_animation_state().set_animation("movement/bobIdle", true, 1)
	idleTrack.set_time_scale(1.5)
	idleTrack.set_alpha(1.65)
	
	var hitTrack = get_animation_state().set_animation("empty", true, 2)
	hitTrack.set_mix_duration(0.5)
