extends Area2D

@export var ink_color: Color = Color.GREEN

func _ready() -> void:
	modulate = ink_color
	connect("body_entered", Callable(self,"_on_body_entered"))
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.set_ink_color(ink_color)
		queue_free()
