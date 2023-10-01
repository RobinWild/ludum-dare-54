extends SpineSprite

var moveTrack: SpineTrackEntry
var otherTrack: SpineTrackEntry
var equippedBow: bool = false

@onready var ikBone: SpineBoneNode = $targetIk
@onready var moveSpeed: float = $"..".moveSpeed
var isTargetting: bool = false

func _ready():
	setAnimations()

func _process(delta):
	get_skeleton().set_to_setup_pose()
	moveTrack.set_time_scale(1.7 * (moveSpeed/130))

func setAnimations():
	moveTrack = get_animation_state().set_animation("movement/walk", true, 1)
	var hitTrack = get_animation_state().set_animation("empty", true, 2)
	otherTrack = get_animation_state().set_animation("empty", true, 3)

func ReceiveHit():
	var trackEntry = get_animation_state().set_animation("hit/getHit", false, 2)
	trackEntry.set_mix_duration(0)
	trackEntry.set_mix_blend(SpineConstant.MixBlend_Add)

func PlayAnimation(animationName, loop, trackIndex, mixTime = 0, alpha = null):
	if not otherTrack.get_animation().get_name() == animationName:
		otherTrack = get_animation_state().set_animation(animationName, loop, trackIndex)
		otherTrack.set_mix_duration(mixTime)
		if alpha != null:
			otherTrack.set_alpha(alpha)

func _input(event):
	if event.is_action_pressed("jump"):
		PlayAnimation("other/attackWindup", false, 3, 0.25)
		PlayAnimation("empty", false, 1, 0.25)
		
