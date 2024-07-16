extends Node
class_name Global


func spawn_effect(
	path: String, offset: Vector2, 
	initial_position: Vector2, is_flipped: bool
):
	var effect: BaseEffect = load(path).instantiate()
	
	if is_flipped:
		offset.x = -offset.x
	effect.global_position = initial_position + offset
	effect.flip_h = is_flipped
	
	get_tree().root.call_deferred("add_child", effect)
