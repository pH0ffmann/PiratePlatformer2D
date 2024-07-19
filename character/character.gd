extends CharacterBody2D
class_name BaseCharacter

const THROWABLE_SWORD: PackedScene = preload("res://throwables/character_sword/character_sword.tscn")
var can_play_dead_ground_animation: bool = true
var on_knockback: bool = false
var has_sword: bool = false
var on_floor: bool = true
var is_alive: bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count: int = 0
var attack_index: int = 1
var air_attack_count: int = 0

@export_category("Variables")
@export var _speed: float = 200.0
@export var _jump_velocity: float = -300.0
@export var character_health: int = 10
@export var knockback_speed: float = 200.0

@export_category("Objects")
@export var collision: CollisionShape2D
@export var chacacter_texture: CharacterTexture
@export var attack_combo: Timer
@export var knockback_timer: Timer


func _process(delta):
	if on_knockback:
		move_and_slide()


func _physics_process(delta):
	vertical_movement(delta)
	if is_alive == false:
		move_and_slide()
		return

	horizontal_movement()
	attack_handler()
	move_and_slide()
	chacacter_texture.animate(velocity)


func vertical_movement(delta: float):	
	if is_on_floor():
		
		if is_alive == false:
			if can_play_dead_ground_animation:
				chacacter_texture.action_animation("dead_ground")
				can_play_dead_ground_animation = false
				set_collision_layer_value(1, false)
				set_collision_mask_value(1, false)
				set_collision_layer_value(2, true)
				set_collision_mask_value(2, true)
				
			velocity.x = 0
			return
		
		if on_floor == false:
			global.spawn_effect(
				"res://visual_effects/dust_particles/fall/fall_effect.tscn",
				Vector2(0, 2), global_position, false
			)
			chacacter_texture.action_animation("land")
			set_physics_process(false)
			on_floor = true
			air_attack_count = 0
			
		jump_count = 0
	
	if not is_on_floor():
		if on_floor:
			attack_index = 1
		on_floor = false
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and jump_count < 2:
		attack_index = 1
		global.spawn_effect(
			"res://visual_effects/dust_particles/jump/jump_effect.tscn",
			Vector2(0, 2), global_position, chacacter_texture.flip_h
		)
		velocity.y = _jump_velocity
		jump_count += 1


func horizontal_movement():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * _speed
		return
	velocity.x = move_toward(velocity.x, 0, _speed)


func attack_handler():
	if not has_sword:
		return
	
	if Input.is_action_just_pressed("throw"):
		chacacter_texture.action_animation("throw_sword")
		set_physics_process(false)
		update_sword_state(false)
		has_sword = false
		return
	
	if Input.is_action_just_pressed("attack") and is_on_floor():
		attack_animation_handler("attack_", 4)

	if (
		Input.is_action_just_pressed("attack") 
		and not is_on_floor() and 
		air_attack_count < 2
	):
		attack_animation_handler("air_attack_", 3, true)


func attack_animation_handler(prefix: String, index_limit: int, on_air: bool = false):
	global.spawn_effect(
		"res://visual_effects/sword/" + 
		prefix + str(attack_index) + 
		"/" + prefix + str(attack_index) + ".tscn",
		Vector2(24, 0), global_position, chacacter_texture.flip_h
	)
	
	chacacter_texture.action_animation(prefix + str(attack_index))
	attack_index += 1
	if attack_index == index_limit:
		attack_index = 1
	set_physics_process(false)
	if on_air:
		air_attack_count += 1
	attack_combo.start()


func throw_sword(is_flipped: bool):
	var sword: CharacterSword = THROWABLE_SWORD.instantiate()
	get_tree().root.call_deferred("add_child", sword)
	sword.global_position = global_position
	if is_flipped:
		sword.direction = Vector2(-1, 0)
		return
	sword.direction = Vector2(1, 0)


func update_sword_state(state: bool):
	has_sword = state
	chacacter_texture.update_suffix(has_sword)
	


func update_health(value: int, entity):
	knockback(entity)
	knockback_timer.start()
	character_health -= value
	
	if character_health <= 0:
		is_alive = false
		update_sword_state(false)
		chacacter_texture.action_animation("dead_hit")
		return
	
	chacacter_texture.action_animation("hit")


func knockback(entity: BaseEnemy):
	var knockback_direction: Vector2 = entity.global_position.direction_to(self.global_position)
	velocity.x = knockback_direction.x * knockback_speed
	velocity.y = -1 * knockback_speed
	on_knockback = true

func _on_attack_combo_timeout():
	attack_index = 1


func _on_knockback_timer_timeout():
	on_knockback = false


func is_player_alive():
	return is_alive
