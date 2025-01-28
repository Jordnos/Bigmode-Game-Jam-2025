extends RigidBody2D

const STATE_NORMAL = "normal"
const STATE_PLUGGED = "plugged"

var state = null
var connected_to = null

@onready var joint = null

func _ready() -> void:
	state = STATE_NORMAL

func _process(delta: float) -> void:
	pass

func plug(outlet: Node2D) -> void:
	if not connected_to:
		connected_to = outlet
		connected_to.set_state(STATE_PLUGGED)
		global_position = connected_to.global_position
		joint = PinJoint2D.new()
		joint.node_a = get_path()
		joint.node_a = connected_to.get_path()
		joint.position = Vector2.ZERO
		add_child(joint)

func unplug() -> void:
	if connected_to:
		connected_to.status = STATE_NORMAL
		joint.queue_free()
		joint = null
