extends Area2D
class_name CollectableComponent


func _on_body_entered(body):
	if body is BaseCharacter:
		consume(body)
		queue_free()


func consume(body: BaseCharacter):
	pass
