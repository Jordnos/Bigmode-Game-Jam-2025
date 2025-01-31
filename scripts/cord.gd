extends Node2D

@onready var max_cord_length = $CordAnchor.position.distance_to($CordPlug.position)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func update_collision_mask(collision: bool) -> void:
	for segment in get_children():
		if segment is RigidBody2D and segment.name != "CordPlug" and segment.name != "CordAnchor":
			segment.collision_layer = 8 if collision else 4

func get_max_cord_length() -> int:
	return max_cord_length
