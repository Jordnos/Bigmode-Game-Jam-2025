extends CharacterBody2D

@export var SPEED = 350.0
@export var JUMP_VELOCITY = -500.0

@onready var manager: Node2D = get_parent()

func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * (2.5 if velocity.y >= 0 else 1)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	#Flip Sprite Direction
	if direction > 0:
		manager.animated_sprite_2d.flip_h = true
	elif direction < 0: 
		manager.animated_sprite_2d.flip_h = false

	#Play animations
	if is_on_floor():
		if direction == 0:
			manager.animated_sprite_2d.play("idle")
		else:
			manager.animated_sprite_2d.play("run")
	else:
		manager.animated_sprite_2d.play("jump")

	#Apply Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	keep_in_cord_range(delta)
	move_and_slide()

func keep_in_cord_range(delta: float) -> void:
	if manager.grab_joint and manager.grab_target:
		var cord = manager.grab_target.get_parent()
		var anchor = manager.grab_target.get_node("../CordAnchor")
		var plug = manager.grab_target

		var cord_length = cord.get_max_cord_length() + 50
		var curr_length = anchor.global_position.distance_to(global_position)

		if curr_length >= cord_length:
			var direction_to_anchor = (anchor.global_position - global_position).normalized()
			var target_position = anchor.global_position - direction_to_anchor * cord_length

			global_position = global_position.lerp(target_position, 1)
			if not is_on_floor():
				manager.toggle_character()
