extends AnimatedSprite2D
class_name CharacterTexture

var is_on_action: bool = false
var suffix: String = ""
@export_category("Objects")
@export var character: BaseCharacter
@export var attack_area_collision: CollisionShape2D

func animate(velocity: Vector2):
	verify_direction(velocity.x)
	
	if is_on_action:
		return

	if not velocity:
		play("idle" + suffix)
		return
		
	if velocity.y:
		if velocity.y > 0:
			play("fall" + suffix)
		
		if velocity.y < 0:
			play("jump" + suffix)
		return
	
	if velocity.x:
		play("run" + suffix)


func verify_direction(direction: float):
	if direction > 0:
		flip_h = false
		attack_area_collision.position.x = 24

	if direction < 0:
		attack_area_collision.position.x = -24
		flip_h = true


func action_animation(action_name: String):
	is_on_action = true
	if action_name == "throw_sword":
		play(action_name)
		return
	play(action_name + suffix)
	


func update_suffix(state: bool):
	if state:
		suffix = "_with_sword"
		return
	suffix = ""


func _on_animation_finished(): 
	is_on_action = false
	character.set_physics_process(true)


func _on_frame_changed():
	var current_animation: StringName = animation
	
	if current_animation.begins_with("air_attack") or current_animation.begins_with("attack"):
		if current_animation.begins_with("air_attack"):
				attack_area_collision.position.y = 24
			
		if current_animation.begins_with("attack"):
				attack_area_collision.position.y = 0

		if frame == 0 or frame == 1:
			attack_area_collision.disabled = false
		if frame == 2:
			attack_area_collision.disabled = true


	if animation.begins_with("attack"):
		if frame == 0 or frame == 1:
			attack_area_collision.disabled = false
		if frame == 2:
			attack_area_collision.disabled = true

	
	if animation == "throw_sword":
		if frame == 1:
			character.throw_sword(flip_h)

	if animation == "run" or animation == "run_with_sword":
		if frame == 1 or frame == 4:
			global.spawn_effect(
			"res://visual_effects/dust_particles/run/run_effect.tscn",
			Vector2(0, 2), global_position, self.flip_h
		)
