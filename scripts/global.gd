extends Node

var current_level = 0
var player_manager = null

const LEVEL_POWER_NEEDED = {
	0: 2,
	1: 1,
	2: 1,
	3: 1,
	4: 2
}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		reset_level()
	if is_instance_valid(player_manager) and current_level < LEVEL_POWER_NEEDED.size(): 
		$"../GameManager/GUI/PowerLevel".text = \
			str(player_manager.power) + "/" + str(LEVEL_POWER_NEEDED[current_level])

func reset_level() -> void:
	get_tree().reload_current_scene()
	player_manager.respawn()

func set_player_manager(node: Node2D) -> void:
	player_manager = node

func init_level(level_scene_path: String) -> bool:
	if ResourceLoader.exists(level_scene_path):
		get_tree().change_scene_to_file(level_scene_path)
		return true
	return false

func go_to_next_level() -> bool:
	if LEVEL_POWER_NEEDED.get(current_level, 0) <= player_manager.get_power():
		if current_level+1 == LEVEL_POWER_NEEDED.size():
			print("game done!")
			$"../GameManager/GameFinished/CanvasLayer".show()
		current_level += 1
		var level_scene_path = "res://scenes/levels/level_" + str(current_level) + ".tscn"
		return init_level(level_scene_path)
	return false
