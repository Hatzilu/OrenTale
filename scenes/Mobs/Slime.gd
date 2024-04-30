extends CharacterBody2D



@export var SPEED = 30
@export var move_dir: Vector2
# The agressor is the player that the slime sees first, if it detects a player via the awareness collision box,
# it will consider that player as the aggressor, and will move towards it to attack
var start_pos: Vector2
var target_pos: Vector2

const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	if target_pos:
		var direction = global_position = global_position.direction_to(target_pos)
		velocity = direction * SPEED * delta
		return
		
			# Add the gravity.
	if not is_on_floor():
		print("not on floor")
		velocity.y += gravity * delta
		
	#global_position = global_position.move_toward(target_pos, SPEED * delta);
	#
	#if global_position == target_pos:
		#target_pos = start_pos + move_dir
	#else:
		#target_pos = start_pos
		#
		
func _on_body_entered(other):
	pass


# if enemy detects player
func _on_detection_area_body_entered(body):
	if !body.is_in_group("Players"):
		return
	target_pos = body.position
	print("touching player")
