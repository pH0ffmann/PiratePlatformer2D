extends AnimatedSprite2D
class_name CharacterTexture

var is_on_action: bool = false
var suffix: String = ""
@export_category("Objects")
@export var character: BaseCharacter

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
	if direction < 0:
		flip_h = true


func action_animation(action_name: String):
	is_on_action = true
	play(action_name + suffix)
	


func update_suffix(state: bool):
	if state:
		suffix = "_with_sword"
		return
	suffix = ""


func _on_animation_finished(): 
	is_on_action = false
	character.set_physics_process(true)
