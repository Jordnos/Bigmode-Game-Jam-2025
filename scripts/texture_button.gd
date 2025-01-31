extends TextureButton

func _on_pressed() -> void:
	Input.action_press("pause")
	await get_tree().create_timer(0.1).timeout  # Wait for a short moment
	Input.action_release("pause")
