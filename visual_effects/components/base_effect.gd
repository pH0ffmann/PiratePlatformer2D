extends AnimatedSprite2D
class_name BaseEffect


func _on_animation_finished():
	queue_free()
