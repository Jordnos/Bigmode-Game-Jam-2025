extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

@onready var pin_joint = $PinJoint2D
@onready var grab_area = $Area2D

var is_grabbed = false
var grab_target = null

func _ready() -> void:
	grab_area.connect("body_entered", Callable(self, "_on_grab_area_body_entered"))
	grab_area.connect("body_exited", Callable(self, "_on_grab_area_body_exited"))

func _process(delta: float) -> void:
	if is_grabbed && grab_target:
		grab_target.global_position = global_position
		
	if Input.is_action_just_pressed("grab"):
		if not is_grabbed and grab_target:
			is_grabbed = true
			self.global_position = grab_target.global_position
			pin_joint.position = grab_target.global_position
			pin_joint.node_a = get_path()
			pin_joint.node_b = grab_target.get_path()
		elif is_grabbed:
			is_grabbed = false
			pin_joint.node_a = ""
			pin_joint.node_b = ""
			

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_grab_area_body_entered(body: Node) -> void:
	if not is_grabbed and body.is_in_group("grabbable"):
		grab_target = body

func _on_grab_area_body_exited(body: Node) -> void:
	if not is_grabbed and body.is_in_group("grabbable"):
		grab_target = null
