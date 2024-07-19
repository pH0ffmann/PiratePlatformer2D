extends AnimatedSprite2D
class_name EnemyTexture

var on_action: bool = false
@export_category("Objects")
@export var enemy: BaseEnemy
@export var attack_area_collision: CollisionShape2D

@export_category("Variables")
@export var last_attack_frame: int


func animate(velocity: Vector2):
	if on_action:
		return
	
	if velocity.y:
		if velocity.y > 0:
			play("fall")

		if velocity.y < 0:
			play("jump")
		
		return
		
	if velocity.x:
		play("run")
		return
	
	play("idle")


func action_animate(action: String):
	enemy.set_physics_process(false)
	on_action = true
	play(action)


func _on_animation_finished():
	if animation == "attack_anticipation":
		action_animate("attack")
		return

	on_action = false
	enemy.set_physics_process(true)


func _on_frame_changed():
	if animation == "attack":
		if frame == 0 or frame == 1:
			attack_area_collision.disabled = false
		if frame == last_attack_frame:
			attack_area_collision.disabled = true
