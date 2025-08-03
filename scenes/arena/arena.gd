extends Node2D

@export var arena_radius := 1000.0
@export var arena_center := Vector2.ZERO

func _ready():
	var segments = 64
	var points = []
	for i in range(segments + 1):
		var angle = TAU * i / segments
		points.append(Vector2(cos(angle),sin(angle)) * arena_radius)
		
	$ArenaBorder.points = points
	$ArenaBorder.width = 10
	$ArenaBorder.default_color = Color(1.0, 0.3, 0.3, 0.6)  # reddish border
