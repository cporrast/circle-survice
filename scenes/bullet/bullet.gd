# Bullet.gd
extends Area2D

@export var speed := 600.0
@export var direction := Vector2.ZERO
@export var target_screen_ratio := 0.02

func move_bullet(delta: float) -> void:
	position += direction.normalized() * speed * delta

func _ready():
	print("Bullet scale:", $Sprite2D.scale)
	print("Collision radius:", $CollisionShape2D.shape.radius)

	scale_visuals($Sprite2D, $CollisionShape2D)
	

		
func _on_body_entered(body):
	print("Hit:", body.name)
		
func scale_visuals(sprite: Sprite2D, collision_shape: CollisionShape2D):
	if not sprite or not collision_shape:
		return

	var screen_size = get_viewport_rect().size
	var target_width = screen_size.x * target_screen_ratio

	var tex_size = sprite.texture.get_size()
	var scale_factor = target_width / tex_size.x
	sprite.scale = Vector2(scale_factor, scale_factor)

	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		var scaled_size = tex_size * scale_factor
		shape.extents = scaled_size * 0.5
	elif shape is CircleShape2D:
		shape.radius = (tex_size.x * scale_factor) * 0.3

	collision_shape.position = sprite.position


func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()
