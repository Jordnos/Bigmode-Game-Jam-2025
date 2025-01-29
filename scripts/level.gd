extends Node2D

func _ready() -> void:
	var player = $Player
	Global.set_player(player)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		restart()

func restart() -> void:
	get_tree().reload_current_scene()
