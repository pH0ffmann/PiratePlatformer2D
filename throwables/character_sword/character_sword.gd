extends ThrowableComponent
class_name CharacterSword


func _on_body_entered(body):
	if body is TileMap:
		queue_free()
