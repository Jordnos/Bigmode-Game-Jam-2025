extends CanvasGroup

func _on_button_toggled(toggled_on: bool) -> void:
	$Label.show() if toggled_on else $Label.hide()
