extends "res://scenes/bullet/bullet.gd"

@onready var sprite: Sprite2D = $Sprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D

func _ready():
	scale_visuals(sprite, shape)
	connect("body_entered", Callable(self, "_on_body_entered"))


func _physics_process(delta: float) -> void:
	move_bullet(delta)
	rotation = direction.angle()


func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Player hit by bullet!")
		queue_free()
