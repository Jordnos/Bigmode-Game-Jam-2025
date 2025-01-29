extends Node2D

const STATE_NORMAL = "normal"
const STATE_PLUGGED = "plugged"

var state = null
var connected_to = null
var power = null

@onready var joint = null

func _ready() -> void:
	state = STATE_NORMAL
	power = true

func _process(delta: float) -> void:
	pass

func get_state() -> String:
	return state

func set_state(new_state: String) -> void:
	if new_state == STATE_NORMAL or new_state == STATE_PLUGGED:
		state = new_state

func plug(cord_plug: Node2D) -> void:
	if not connected_to:
		connected_to = cord_plug
		connected_to.set_state(connected_to.STATE_PLUGGED)
		state = STATE_PLUGGED
		connected_to.global_position = global_position
		joint = PinJoint2D.new()
		joint.node_a = get_path()
		joint.node_b = connected_to.get_path()
		joint.position = Vector2.ZERO
		add_child(joint)
		connected_to.get_parent().update_collision_mask(true)

func unplug() -> void:
	if connected_to:
		connected_to.get_parent().update_collision_mask(false)
		connected_to.set_state(connected_to.STATE_NORMAL)
		connected_to = null
		state = STATE_NORMAL
		joint.queue_free()
		joint = null

func take_power() -> bool:
	if power == true:
		power = false
		return true
	return false
