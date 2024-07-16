extends Area2D
class_name ThrowableComponent

var direction: Vector2

@export_category("Variables")
@export var move_speed: float = 128.0

func _on_body_entered(body):
	pass # Replace with function body.


func _physics_process(delta: float):
	translate(direction * delta * move_speed)
