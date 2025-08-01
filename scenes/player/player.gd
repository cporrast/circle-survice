extends CharacterBody2D

@export var speed = 400
@onready var _animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_direction = get_input()
	velocity = input_direction * speed
	
	move_and_slide()
	animate(input_direction)
	


func get_input():
	return Input.get_vector("left", "right", "up", "down")
	
	
func animate(direction: Vector2):
	if direction != Vector2.ZERO:
		_animated_sprite.play("walk")
		if direction.x != 0:
			_animated_sprite.flip_h = direction.x < 0
	else:
		_animated_sprite.play("idle")
		
