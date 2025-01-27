extends CharacterBody2D

@export var SPEED = 350.0
@export var JUMP_VELOCITY = -400.0
@export var SWING_FORCE = 500

@onready var pin_joint = $PinJoint2D
@onready var grab_area = $Area2D

var grab_target = null
var grab_joint = null

func _ready() -> void:
	grab_area.connect("body_entered", Callable(self, "_on_grab_area_body_entered"))
	grab_area.connect("body_exited", Callable(self, "_on_grab_area_body_exited"))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not is_on_floor() and grab_joint:
		do_swinging_process(delta)
	else:
		do_normal_process(delta)

	move_and_slide()

	keep_player_in_cord_range()

	if Input.is_action_just_pressed("grab"):
		if not grab_joint and grab_target:
			plug_in()
		elif grab_joint:
			unplug()

func _on_grab_area_body_entered(body: Node) -> void:
	if not grab_joint and body.is_in_group("grabbable"):
		grab_target = body

func _on_grab_area_body_exited(body: Node) -> void:
	if not grab_joint and body.is_in_group("grabbable"):
		grab_target = null

func do_swinging_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SWING_FORCE * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func do_normal_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func plug_in() -> void:
	if grab_target:
		grab_target.global_position = self.global_position
		grab_joint = PinJoint2D.new()
		grab_joint.node_a = get_path()
		grab_joint.node_b = grab_target.get_path()
		grab_joint.position = Vector2.ZERO
		add_child(grab_joint)

func unplug() -> void:
	if grab_joint:
		grab_joint.queue_free()
		grab_joint = null

func keep_player_in_cord_range() -> void:
	if grab_joint and grab_target:
		var cord = grab_target.get_parent()
		var anchor = grab_target.get_node("../CordAnchor")
		var plug = grab_target

		var cord_length = cord.max_cord_length
		var curr_length = anchor.position.distance_to(plug.position)

		if curr_length >= cord_length:
			global_position = anchor.global_position + \
				(global_position - anchor.global_position).normalized() * cord_length
