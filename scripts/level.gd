extends Node2D

var player_manager: Node2D

func _ready() -> void:
	player_manager = $PlayerManager
	Global.set_player_manager(player_manager)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		restart()

func restart() -> void:
	get_tree().reload_current_scene()
	player_manager.respawn()
