extends Node2D

@onready var length: float = $WorldObjectCollider.shape.extents.x * 2
var parallaxScalar: float = 2

var childSprites = []

func _ready():
	GetChildSprites()

func _process(delta):
	if global_position.x < 10:
		queue_free()
	ApplyParallaxMotion(delta)

func GetChildSprites():
	for i in self.get_children():
		if i is Sprite2D:
			childSprites.append(i)

func ApplyParallaxMotion(delta):
	for i in childSprites:
		i.global_position.x -= i.z_index * parallaxScalar * delta
