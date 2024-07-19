extends CharacterBody2D
class_name BaseEnemy

enum types {
	STATIC = 0, CHASE = 1, WANDER = 2
}


var player_in_range: BaseCharacter = null
var direction: Vector2 = Vector2.ZERO
var on_knockback: bool = false
var can_play_dead_ground_animation: bool = true
var is_alive: bool = true
var on_floor: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export_category("Objects")
@export var enemy_texture: EnemyTexture
@export var floor_detection_ray: RayCast2D
@export var knockback_timer: Timer

@export_category("Variables")
@export var pink_star_enemy: bool = false
@export var enemy_type: types
@export var move_speed: float = 128
@export var knockback_speed : float = 256.0
@export var enemy_health: int = 10
@export var hit_knockback_timer: float = 0.4
@export var dead_knockback_timer: float = 0.4


func _ready():
	direction = [Vector2(-1, 0), Vector2(1, 0)].pick_random()
	update_direction()


func _process(delta):
	if on_knockback:
		move_and_slide()



func _physics_process(delta):
	vertical_movement(delta)
	if is_alive == false:
		move_and_slide()
		return
	
	if is_instance_valid(player_in_range):
		attack()
		return
	
	match enemy_type:
		types.STATIC:
			print("Estatico")
		
		types.CHASE:
			print("Perseguidor")
			
		types.WANDER:
			wandering()
	
	move_and_slide()
	
	enemy_texture.animate(velocity)


func vertical_movement(delta: float):
	if is_on_floor():
		if is_alive == false:
			if can_play_dead_ground_animation:
				can_play_dead_ground_animation = false
				enemy_texture.action_animate("dead_ground")
			velocity.x = 0
			return
		if on_floor == false:
			enemy_texture.action_animate("land")
			on_floor = true

	if not is_on_floor():
		on_floor = false
		velocity.y += gravity * delta


func wandering():
	if floor_detection_ray.is_colliding():
		if floor_detection_ray.get_collider() is TileMap:
			velocity.x = direction.x * move_speed
			return
	
	if is_on_floor():
		update_direction()
		velocity.x = 0
	


func update_direction():
	direction.x = -direction.x
	if pink_star_enemy:
		if direction.x > 0:
			enemy_texture.flip_h = true
		if direction.x < 0:
			enemy_texture.flip_h = false

	if direction.x > 0:
		floor_detection_ray.position.x = 12
	if direction.x < 0:
		floor_detection_ray.position.x = -12


func attack():
	pass


func update_health(damage: int, entity):
	if is_alive == false:
		return
	
	knockback(entity)
	enemy_health -= damage
	if enemy_health <= 0:
		knockback_timer.start(dead_knockback_timer)
		kill()
		return
	
	knockback_timer.start(hit_knockback_timer)
	enemy_texture.action_animate("hit")


func knockback(entity: BaseCharacter):
	var knockback_direction: Vector2 = entity.global_position.direction_to(global_position)
	velocity.x = knockback_direction.x * knockback_speed
	velocity.y = -1 * knockback_speed
	on_knockback = true



func kill():
	enemy_texture.action_animate("dead_hit")
	is_alive = false


func _on_detection_area_body_entered(body):
	if body is BaseCharacter:
		player_in_range = body


func _on_detection_area_body_exited(body):
	if body is BaseCharacter:
		player_in_range = null


func _on_knockback_timer_timeout():
	on_knockback = false
