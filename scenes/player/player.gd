extends CharacterBody2D

@export var speed = 800
@onready var body: Sprite2D = $BodySprite
@onready var head: Sprite2D = $Head/HeadSprite

var input_direction := Vector2.ZERO

func _ready() -> void:
	var arena = get_parent().get_node("Arena")
	var arena_center = arena.global_position
	var arena_radius = arena.arena_radius

	# Step 1: Scale player relative to arena
	var player_target_diameter = arena_radius * 0.48  # Up to 48% of diameter
	var max_pixel_size = 160.0  # ← Cap size in pixels (tweak this as needed)
	player_target_diameter = min(player_target_diameter, max_pixel_size)

	var texture_size = body.get_texture().get_size().x
	var scale_factor = player_target_diameter / texture_size

	body.scale = Vector2(scale_factor, scale_factor)
	head.scale = Vector2(scale_factor, scale_factor)
	
	var hitbox := $CollisionShape2D
	
	if body.is_in_group("player"):
		body.take_damage()
		
	if hitbox.shape is CircleShape2D:
		var visual_radius = (body.get_texture().get_size().x * body.scale.x)
		hitbox.shape.radius = visual_radius  # ← tweak this multiplier for tighter or looser hitbox

	# Step 2: Clamp player position inside arena bounds
	await get_tree().process_frame
	var body_radius = (body.get_rect().size.x * body.scale.x) / 2.0
	var max_distance = arena_radius - body_radius

	var offset = global_position - arena_center
	if offset.length() > max_distance:
		global_position = arena_center + offset.normalized() * max_distance



func _physics_process(delta: float) -> void:
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	velocity = input_direction * speed
	move_and_slide()
	
	var body_radius = (body.get_rect().size.x * body.scale.x) / 2.0

	if velocity.length() > 0:
		var direction = velocity.normalized()
		var rotation_amount = velocity.length() * delta * 0.08
		var roll_direction = Vector2(0, 1).cross(direction)
		body.rotation += rotation_amount * roll_direction

		# Slight head tilt toward movement direction
		var target_angle = velocity.angle()
		var current_angle = head.rotation
		var diff = wrapf(target_angle - current_angle, -PI, PI)
		head.rotation += clamp(diff, -0.05, 0.05)

	# Animate head position around top arc
	#var body_radius = (body.get_texture().get_size().y * body.scale.y) / 2.0
	var max_head_offset = body_radius * 0.5
	var head_direction = input_direction if input_direction.length() > 0.1 else Vector2.ZERO

	var offset_head = head_direction.normalized() * max_head_offset
	offset_head.y -= body_radius * 0.9
	$Head.position = offset_head
	
	var arena = get_parent().get_node("Arena")
	var arena_center = arena.global_position
	var arena_radius = arena.arena_radius
#
	#var player_radius = (body.get_texture().get_size().x * body.scale.x) / 2.0
	var max_distance = arena_radius - body_radius

	var offset = global_position - arena_center

	if offset.length() > max_distance:
		global_position = arena_center + offset.normalized() * max_distance
