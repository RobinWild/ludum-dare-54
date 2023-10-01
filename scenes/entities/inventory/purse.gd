extends Area2D

var score: int

func _ready():
	$"../Label".text = "$" + str(score)


func _process(delta):
	pass

func _physics_process(delta):
	for i in get_overlapping_areas():
		print(i)
		var item = i.get_parent().get_parent()
		if item.itemId == "coin":
			$"../..".RemoveItem(item)
			item.queue_free()
			score += $"../..".itemPower + 1
			print(score)
			$"../Label".text = "$" + str(score)
