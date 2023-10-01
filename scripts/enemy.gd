extends Node2D

@export var moveSpeed: float = 50
@export var health: int = 3

func _ready():
	pass # Replace with function body.


func _process(delta):
	if health > 0:
		global_position.x -= moveSpeed * delta
	if global_position.x < -100:
		queue_free()

func ReceiveHit(damage = 1):
	$SpineSprite.ReceiveHit()
	health -= damage
	if health <= 0:
		$SpineSprite.PlayAnimation("other/die", false, 3, 0)
		$AttackArea/AttackCollider.disabled = true
		$StartAttackArea/StartAttackCollider.disabled = true
		$EnemyArea/EnemyCollider.disabled = true

func _on_start_attack_area_area_entered(area):
	if health > 0:
		moveSpeed = 0
		$SpineSprite.PlayAnimation("other/attackWindup", false, 3, 0.25)
		$SpineSprite.PlayAnimation("empty", false, 1, 0.25)

func _on_attack_area_area_entered(area):
	if health > 0:
		$SpineSprite.PlayAnimation("other/attack", false, 3, 0)
