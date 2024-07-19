extends Area2D
class_name EnemyAttackArea

@export_category("Variables")
@export var attack_damage: int = 1


func _on_body_entered(body):
	if body is BaseCharacter:
		body.update_health(attack_damage, get_parent())
