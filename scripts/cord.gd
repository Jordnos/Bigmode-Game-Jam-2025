extends Node2D

@onready var max_cord_length = $CordAnchor.position.distance_to($Plug.position)

var collision_enabled = false

func _ready() -> void:
	update_collision_mask()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("rope_collision"):
		collision_enabled = not collision_enabled
		update_collision_mask()

func update_collision_mask() -> void:
	for segment in get_children():
		if segment is RigidBody2D and segment.name != "Plug":
			segment.set_collision_mask_value(1, collision_enabled)

func get_max_cord_length() -> int:
	return max_cord_length
