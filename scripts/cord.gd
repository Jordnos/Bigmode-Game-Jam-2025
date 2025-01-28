extends Node2D

@onready var max_cord_length = $CordAnchor.position.distance_to($Plug.position)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func update_collision_mask(collision: bool) -> void:
	for segment in get_children():
		if segment is RigidBody2D and segment.name != "Plug" and segment.name != "CordAnchor":
			segment.set_collision_mask_value(1, collision)

func get_max_cord_length() -> int:
	return max_cord_length
