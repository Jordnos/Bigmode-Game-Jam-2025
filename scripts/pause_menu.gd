extends Node2D

@onready var menu = $CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not menu.visible:
			pause()
		else:
			unpause()

func _on_resume_pressed() -> void:
	unpause()

func _on_exit_pressed() -> void:
	unpause()
	$"/root/GameManager/GUI".hide()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func pause() -> void:
	get_tree().paused = true
	menu.show()

func unpause() -> void:
	menu.hide()
	get_tree().paused = false
