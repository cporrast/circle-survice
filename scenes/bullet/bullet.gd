extends Area2D

@export var speed := 500.0
@export var direction := Vector2.ZERO
@export var target_screen_ratio := 0.02

func _ready():
	print("Bullet scale:", $Sprite2D.scale)
	print("Collision radius:", $CollisionShape2D.shape.radius)

	scale_visuals($Sprite2D, $CollisionShape2D)
	connect("body_entered", Callable(self, "_on_body_entered"))

func move_bullet(delta: float) -> void:
	position += direction.normalized() * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()

func scale_visuals(sprite: Sprite2D, collision_shape: CollisionShape2D):
	if not sprite or not collision_shape:
		return

	var screen_size = get_viewport_rect().size
	var target_width = screen_size.x * target_screen_ratio
	var min_width = 82.0
	target_width = max(target_width, min_width)

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
