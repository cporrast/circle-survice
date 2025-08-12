extends Node

var score: int = 0
var bullet_count: int = 0
var time_elapsed: float = 0.0
var final_score: int = 0

@onready var label: Label = get_node_or_null("CanvasLayer/ScoreLabel")

func _process(delta: float) -> void:
	time_elapsed += delta
	update_score()

func add_bullet() -> void:
	bullet_count += 1
	update_score()

func update_score() -> void:
	score = int(time_elapsed * bullet_count)
	if label:
		label.text = "Score: %d" % score

func reset_score() -> void:
	score = 0
	bullet_count = 0
	time_elapsed = 0.0
	if label:
		label.text = "Score: 0"

func save_score() -> void:
	final_score = score
	print("Saving final score:", final_score)
