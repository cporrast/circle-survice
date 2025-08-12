extends CharacterBody2D

@export var speed = 800
@onready var body: Sprite2D = $BodySprite
@onready var head: Sprite2D = $Head/HeadSprite
@onready var cooldown_bar := get_tree().current_scene.get_node("BoostCooldownBar")

var input_direction := Vector2.ZERO
var base_speed := 400
var boost_speed := 900

var cooldown_timer := 0.0
var boost_timer := 0.0

var boost_duration := 2.0
var boost_cooldown := 8.0
var boosted := false

func _ready() -> void:
	var arena = get_parent().get_node("Arena")
	var arena_center = arena.global_position
	var arena_radius = arena.arena_radius

	# Scale player relative to arena
	var player_target_diameter = arena_radius * 0.25
	var max_pixel_size = 160.0
	player_target_diameter = min(player_target_diameter, max_pixel_size)

	var texture_size = body.get_texture().get_size().x
	var scale_factor = player_target_diameter / texture_size

	body.scale = Vector2(scale_factor, scale_factor)
	head.scale = Vector2(scale_factor, scale_factor)

	var hitbox := $CollisionShape2D
	if hitbox.shape is CircleShape2D:
		var visual_radius = (body.get_texture().get_size().x * body.scale.x)
		hitbox.shape.radius = visual_radius * 0.5  # tweak multiplier if needed


	# Clamp inside arena
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
	var current_speed = speed
	velocity = input_direction * current_speed
	

	var body_radius = (body.get_rect().size.x * body.scale.x) / 2.0

	if velocity.length() > 0:
		var direction = velocity.normalized()
		var rotation_amount = velocity.length() * delta * 0.08
		var roll_direction = Vector2(0, 1).cross(direction)
		body.rotation += rotation_amount * roll_direction

		var target_angle = velocity.angle()
		var current_angle = head.rotation
		var diff = wrapf(target_angle - current_angle, -PI, PI)
		head.rotation += clamp(diff, -0.05, 0.05)

	var max_head_offset = body_radius * 0.5
	var head_direction = input_direction if input_direction.length() > 0.1 else Vector2.ZERO
	var offset_head = head_direction.normalized() * max_head_offset
	offset_head.y -= body_radius * 0.9
	$Head.position = offset_head.round()

	var arena = get_parent().get_node("Arena")
	var arena_center = arena.global_position
	var arena_radius = arena.arena_radius
	var max_distance = arena_radius - body_radius
	var offset = global_position - arena_center
	if offset.length() > max_distance:
		global_position = arena_center + offset.normalized() * max_distance
		
		
	if Input.is_action_just_pressed("ability") and not boosted and cooldown_timer <= 0.0:
		boosted = true
		speed = boost_speed
		boost_timer = boost_duration
		cooldown_timer = boost_cooldown

	if boosted:
		boost_timer -= delta
		if boost_timer <= 0.0:
			boosted = false
			speed = base_speed
	
	if cooldown_timer > 0.0:
		cooldown_timer -= delta
	
	current_speed	 = boost_speed if boosted else speed
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	velocity = input_direction * current_speed
	
	move_and_slide()
	
	
	if cooldown_bar:
		cooldown_bar.value = boost_cooldown - cooldown_timer
	
	
func take_damage():
	print("Player hit. Game Over.")
	ScoreManager.save_score()
	#$Fin alScoreLabel.text = "Final Score: %d" % score
	get_tree().change_scene_to_file("res://scenes/ui/game_ver/game_over_screen.tscn")
