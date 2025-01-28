extends Node2D

const STATE_NORMAL = "normal"
const STATE_PLUGGED = "plugged"

var state = null;

func _ready() -> void:
	state = STATE_NORMAL

func _process(delta: float) -> void:
	pass

func get_state() -> String:
	return state

func set_state(new_state: String) -> void:
	state = new_state
