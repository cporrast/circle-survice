extends CanvasLayer

@onready var play_button := $CenterContainer/VBoxContainer/Panel/Button

@onready var fade := $FadeRect
@onready var tween := create_tween()

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	fade.modulate.a = 1.0
	tween.tween_property(fade, "modulate:a", 0.0, 1.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	play_button.grab_focus()



func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	#get_tree().paused = false
	#self.queue_free()  # remove login screen
