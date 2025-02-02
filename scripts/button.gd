extends Button

func _ready() -> void:
	focus_mode = FocusMode.FOCUS_NONE
	
func _on_pressed() -> void:
	$Label.visible = not $Label.visible
