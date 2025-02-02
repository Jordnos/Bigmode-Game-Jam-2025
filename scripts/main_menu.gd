extends Node2D

func _ready() -> void:
	if Global.current_level != 0:
		get_node("CanvasLayer/Start").text = "Continue"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_" + str(Global.current_level) + ".tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
