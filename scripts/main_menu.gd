extends Node2D

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_" + str(Global.current_level) + ".tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
