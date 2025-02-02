# Character used when on rope / swinging for physics
extends RigidBody2D

@export var SPEED = 50

@onready var manager: Node2D = get_parent()
@onready var raycast: RayCast2D = $RayCast2D

var is_on_floor: bool = false

func _physics_process(delta: float) -> void:
	raycast.force_raycast_update()
	is_on_floor = raycast.is_colliding()
	
	if is_on_floor:
		manager.toggle_character()
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		manager.animated_sprite_2d.flip_h = false
	elif direction < 0: 
		manager.animated_sprite_2d.flip_h = true

	if Input.is_action_just_pressed("jump") and manager.grab_joint:
		manager.unplug_from_cord()
		apply_impulse(Vector2(0,100))

	manager.animated_sprite_2d.play("jump")

	apply_impulse(Vector2(SPEED*direction,0))
