extends Node2D

@export var moveSpeed: float = 50
@export var health: int = 3
@export var possibleLoot:Array[PackedScene]
var dead

func _ready():
	pass # Replace with function body.


func _process(delta):
	if health > 0:
		global_position.x -= moveSpeed * delta
	if global_position.x < -500:
		queue_free()

func ReceiveHit(damage = 1):
	if not dead:
		$SpineSprite.ReceiveHit()
		health -= damage
		if health <= 0:
			dead = true
			InstantiateItem()
			$SpineSprite.PlayAnimation("other/die", false, 3, 0)
			$AttackArea/AttackCollider.disabled = true
			$StartAttackArea/StartAttackCollider.disabled = true
			$EnemyArea/EnemyCollider.disabled = true
			$StartAttackArea.queue_free()
			$AttackArea.queue_free()
			$EnemyArea.queue_free()

func _on_start_attack_area_area_entered(area):
	if health > 0:
		moveSpeed = 0
		$SpineSprite.PlayAnimation("other/attackWindup", false, 3, 0.25)
		$SpineSprite.PlayAnimation("empty", false, 1, 0.25)

func _on_attack_area_area_entered(area):
	if health > 0:
		$SpineSprite.PlayAnimation("other/attack", false, 3, 0)

func InstantiateItem():
	var randScene = randi_range(0, possibleLoot.size()-1)
	var newItem = possibleLoot[randScene].instantiate()
	add_child(newItem)
	newItem.global_position = global_position + Vector2(0,-100)
	newItem.rotation_degrees = 90 * (randi_range(0, 3))
