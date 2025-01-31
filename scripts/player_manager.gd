extends Node2D

@export var character_body_scene: PackedScene
@export var rigid_body_scene: PackedScene

@export var SPEED = 350.0
@export var JUMP_VELOCITY = -500.0

var current_character: Node2D
var interact_area: Area2D
var animated_sprite_2d: AnimatedSprite2D

var power = 0
var grab_joint = null
var grab_target = null
var interact_target = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_character(character_body_scene)
	
func spawn_character(scene: PackedScene):
	if current_character:
		print("SWAPPIN")
		position = current_character.global_position
		current_character.queue_free()

	current_character = scene.instantiate()
	add_child(current_character)
	current_character.global_position = position
	if grab_joint:
		unplug_from_cord()
		plug_into_cord()

	interact_area = current_character.get_node("Area2D")
	animated_sprite_2d = current_character.get_node("AnimatedSprite2D")
	interact_area.connect("body_entered", Callable(self, "_on_interactable_area_body_entered"))
	interact_area.connect("body_exited", Callable(self, "_on_interactable_area_body_exited"))

func respawn() -> void:
	current_character.queue_free()
	spawn_character(character_body_scene)

func toggle_character():
	if current_character is CharacterBody2D:
		spawn_character(rigid_body_scene)
	else:
		spawn_character(character_body_scene)

func _input(event):
	if event.is_action_pressed("toggle_physics"):
		toggle_character()

func _process(delta: float) -> void:
	#print(interact_target)
	if Input.is_action_just_pressed("grab"):
		if not grab_joint and grab_target:
			if grab_target.get_state() == grab_target.STATE_PLUGGED:
				interact_target.unplug()
			else:
				plug_into_cord()
		elif grab_joint:
			unplug_from_cord()

	if Input.is_action_just_pressed("interact"):
		if not interact_target:
			return

		if interact_target.is_in_group("outlet"):
			if interact_target.get_state() == interact_target.STATE_NORMAL:
				if grab_joint: # plug if holding cord
					unplug_from_cord()
					interact_target.plug(grab_target)
				else:
					var power_gain = interact_target.take_power()
					if power_gain == 0:
						print("no power up sadge")
					else:
						print("POWER UP ANIMATION")
					power += power_gain

			elif interact_target.get_state() == interact_target.STATE_PLUGGED:
				interact_target.unplug()

		elif interact_target.is_in_group("door"):
			if Global.go_to_next_level():
				power = 0
				print("PLAY POV TRANSITION SCENE")

func _on_interactable_area_body_entered(body: Node) -> void:
	if not grab_joint and body.is_in_group("grabbable"):
		grab_target = body
	if body.is_in_group("interactable"):
		interact_target = body

func _on_interactable_area_body_exited(body: Node) -> void:
	if not grab_joint and body.is_in_group("grabbable"):
		grab_target = null
	if body.is_in_group("interactable"):
		interact_target = null

func plug_into_cord() -> void:
	if grab_target:
		grab_joint = PinJoint2D.new()
		grab_target.global_position = current_character.global_position
		grab_joint.position = Vector2.ZERO
		grab_joint.node_a = current_character.get_path()
		grab_joint.node_b = grab_target.get_path()
		current_character.add_child(grab_joint)

func unplug_from_cord() -> void:
	if grab_joint:
		grab_joint.queue_free()
		grab_joint = null

func get_power() -> int:
	return power
