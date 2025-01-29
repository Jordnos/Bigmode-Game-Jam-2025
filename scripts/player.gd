extends CharacterBody2D

@export var SPEED = 350.0
@export var JUMP_VELOCITY = -500.0

@onready var interact_area = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var power = 0
var grab_joint = null
var grab_target = null
var interact_target = null

func _ready() -> void:
	interact_area.connect("body_entered", Callable(self, "_on_interactable_area_body_entered"))
	interact_area.connect("body_exited", Callable(self, "_on_interactable_area_body_exited"))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("grab"):
		if not grab_joint and grab_target:
			if grab_target.get_state() == grab_target.STATE_PLUGGED:
				interact_target.unplug()
			else:
				plug_into_cord()
		elif grab_joint:
			unplug_from_cord()

	if Input.is_action_just_pressed("interact"):
		if interact_target and interact_target.is_in_group("outlet"):  # assume only interactable is outlet rn
			if interact_target.get_state() == interact_target.STATE_NORMAL:
				if grab_joint: # plug if holding cord
					unplug_from_cord()
					interact_target.plug(grab_target)
				else:
					power += interact_target.take_power()
					print(power)

			elif interact_target.get_state() == interact_target.STATE_PLUGGED:
				interact_target.unplug()
		elif interact_target and interact_target.is_in_group("door"):
			print("HI")
			print(Global.go_to_next_level())
			

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * (2.5 if velocity.y >= 0 else 1)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if not interact_target and grab_joint and Input.is_action_just_pressed("interact"):
		velocity.y = JUMP_VELOCITY
		unplug_from_cord()

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")

	#Flip Sprite Direction
	if direction > 0:
		animated_sprite_2d.flip_h = true
	elif direction < 0: 
		animated_sprite_2d.flip_h = false

	#Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")

	#Apply Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	keep_player_in_cord_range()

func _on_interactable_area_body_entered(body: Node) -> void:
	if not grab_joint and body.is_in_group("grabbable"):
		grab_target = body
	if body.is_in_group("interactable"):
		interact_target = body
		print(interact_target.name)

func _on_interactable_area_body_exited(body: Node) -> void:
	if not grab_joint and body.is_in_group("grabbable"):
		grab_target = null
	if body.is_in_group("interactable"):
		interact_target = null

func plug_into_cord() -> void:
	if grab_target:
		grab_target.global_position = self.global_position
		grab_joint = PinJoint2D.new()
		grab_joint.node_a = get_path()
		grab_joint.node_b = grab_target.get_path()
		grab_joint.position = Vector2.ZERO
		add_child(grab_joint)

func unplug_from_cord() -> void:
	if grab_joint:
		grab_joint.queue_free()
		grab_joint = null

func keep_player_in_cord_range() -> void:
	if grab_joint and grab_target:
		var cord = grab_target.get_parent()
		var anchor = grab_target.get_node("../CordAnchor")
		var plug = grab_target

		var cord_length = cord.get_max_cord_length()
		var curr_length = anchor.position.distance_to(plug.position)

		if curr_length >= cord_length:
			global_position = anchor.global_position + \
				(global_position - anchor.global_position).normalized() * cord_length

func get_power() -> int:
	return power
