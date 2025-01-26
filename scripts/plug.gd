extends RigidBody2D

signal player_nearby

@onready var interaction_area = $Area2D

#func _ready():
	#interaction_area.connect("body_entered", self, "_on_body_entered")
	#interaction_area.connect("body_exited", self, "_on_body_exited")
	
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  
		emit_signal("player_nearby", true)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		emit_signal("player_nearby", false)
