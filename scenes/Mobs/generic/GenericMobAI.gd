extends CharacterBody2D


@onready var animation = $AnimatedSprite2D
@onready var detection_area = $Area2D
@export var SPEED = 300
@export var move_dir: Vector2

const ACTION_DURATION_SECONDS = 5
const AGGRO_DURATION_SECONDS = 5

var current_action: int

var time_until_next_action = ACTION_DURATION_SECONDS

var Action = {
	IDLE = 0,
	MOVE_LEFT = 1,
	MOVE_RIGHT = 2
}

# This is the position of the player that aggro'd the mob, if it's nil, then there's no aggro
var target_pos: Vector2

var aggro_timer = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _handle_action():
	var new_action = randi() % Action.size()
	current_action = new_action

func _ready():
	current_action = Action.IDLE
	

func _process(delta):
	if aggro_timer > 0:
		aggro_timer -= 1 * delta
		return
		
	if time_until_next_action > 0:
		time_until_next_action -= 1 * delta
		return
	
	time_until_next_action = ACTION_DURATION_SECONDS
	_handle_action()
	print("new action: %s" % current_action)
	
func _physics_process(delta):
	#if is_on_floor() && velocity.x != 0:
		#sprite_2d.animation = "walk"
	#else:
		#sprite_2d.animation = "default"
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# If the mob is aggroed, just  move towards the player
	if target_pos && aggro_timer > 0:
		velocity.x = move_toward(global_position.x, target_pos.x, delta)

		#global_position = velocity * SPEED * delta
		move_and_slide()
		return
		
	if current_action == Action.MOVE_LEFT:
		velocity.x = SPEED * delta
		animation.flip_h = false
		animation.play("walk")
		
	if current_action == Action.MOVE_RIGHT:
		velocity.x = (SPEED * delta) * (-1)
		animation.flip_h = true
		animation.play("walk")
		
	elif current_action == Action.IDLE:
		velocity.x = move_toward(velocity.x, 0, 50)
		animation.play("default")
	move_and_slide()

# Handle mob aggro onto player if detected
func _on_area_2d_body_entered(body):
	if !body.is_in_group("Players"):
		return
	aggro_timer = AGGRO_DURATION_SECONDS
	target_pos = body.position
