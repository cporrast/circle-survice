extends "res://scenes/bullet/bullet.gd"

@onready var sprite: Sprite2D = $Sprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var arena := get_tree().get_current_scene().get_node("Arena")

var has_entered_arena := false
var bounce_count := 0
@export var max_bounces := 8


var bounce_colors := {
	3: Color(1.0, 1.0, 0.9),  # yellow
	5: Color(1.0, 0.6, 0.0),  # orange
	7: Color(1.0, 0.1, 0.1)   # red
}

func _ready():
	scale_visuals(sprite, shape)
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	move_bullet(delta)

	var offset = position - arena.arena_center
	var distance = offset.length()
	var bullet_radius = get_bullet_radius()

	if not has_entered_arena:
		if distance <= (arena.arena_radius - bullet_radius):
			has_entered_arena = true
	else:
		if distance >= (arena.arena_radius - bullet_radius):
			direction = bounce_direction(offset.normalized())
			position = arena.arena_center + offset.normalized() * (arena.arena_radius - get_bullet_radius() - 1.0)
			
			bounce_count += 1
			if bounce_colors.has(bounce_count):
				sprite.modulate = bounce_colors[bounce_count]
			if bounce_count >= max_bounces:
				queue_free()


func get_bullet_radius() -> float:
	return (sprite.texture.get_size().x * sprite.scale.x) / 2.0
	
	
func bounce_direction(normal: Vector2) -> Vector2:
	var bounced = direction.bounce(normal)
	var angle_variation = deg_to_rad(randf_range(-15, 15))  # tweak this range for more/less chaos
	bounced = bounced.rotated(angle_variation).normalized()
	return bounced
	
#func _on_body_entered(body):
	#if body.is_in_group("player"):
		#print("Player hit by bullet!")
		#queue_free()
