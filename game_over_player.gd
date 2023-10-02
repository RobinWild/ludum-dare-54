extends SpineSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	get_animation_state().set_animation("hit/dead", true, 1)
	$"../GameOverAnimationPlayer".play("empty")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
