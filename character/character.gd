extends CharacterBody2D
class_name BaseCharacter

var has_sword: bool = false
var on_floor: bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count: int = 0

@export_category("Variables")
@export var _speed: float = 200.0
@export var _jump_velocity: float = -300.0
@export_category("Objects")
@export var chacacter_texture: CharacterTexture


func _physics_process(delta):
	vertical_movement(delta)
	horizontal_movement()
	move_and_slide()
	chacacter_texture.animate(velocity)


func vertical_movement(delta: float):
	if is_on_floor():
		if on_floor == false:
			chacacter_texture.action_animation("land")
			set_physics_process(false)
			on_floor = true
			
		jump_count = 0
	
	if not is_on_floor():
		on_floor = false
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and jump_count < 2:
		velocity.y = _jump_velocity
		jump_count += 1


func horizontal_movement():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * _speed
		return
	velocity.x = move_toward(velocity.x, 0, _speed)


func update_sword_state(state: bool):
	has_sword = state
	chacacter_texture.update_suffix(has_sword)
	
