extends Node

var current_level = 0
var player = null

const LEVEL_POWER_NEEDED = {
	0: 2,
	1: 1
}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func set_player(player_node: CharacterBody2D) -> void:
	player = player_node

func go_to_next_level() -> bool:
	if LEVEL_POWER_NEEDED.get(current_level, 0) <= player.get_power():
		current_level += 1
		var level_scene_path = "res://scenes/levels/level_" + str(current_level) + ".tscn"
		if ResourceLoader.exists(level_scene_path):
			get_tree().change_scene_to_file(level_scene_path)
			return true
	return false
