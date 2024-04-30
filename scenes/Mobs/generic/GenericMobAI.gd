extends CharacterBody2D


@onready var animation = $AnimatedSprite2D
@export var SPEED = 300
@export var move_dir: Vector2

const ACTION_DURATION_SECONDS = 5

var current_action: int

var time_until_next_action = ACTION_DURATION_SECONDS

var Action = {
	IDLE = 0,
	MOVE_LEFT = 1,
	MOVE_RIGHT = 2
}


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _handle_action(delta):
	var new_action = randi() % Action.size()
	current_action = new_action

func _ready():
	current_action = Action.IDLE
	

func _process(delta):
	if time_until_next_action > 0:
		time_until_next_action -= 1 * delta
		return
	
	time_until_next_action = ACTION_DURATION_SECONDS
	_handle_action(delta)
	print("new action: %s" % current_action)
	
func _physics_process(delta):
	#if is_on_floor() && velocity.x != 0:
		#sprite_2d.animation = "walk"
	#else:
		#sprite_2d.animation = "default"
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if current_action == Action.MOVE_LEFT:
		velocity.x = SPEED * delta
		animation.flip_h = false
		animation.play("walk")
		
	if current_action == Action.MOVE_RIGHT:
		velocity.x = (SPEED * delta) * (-1)
		animation.flip_h = true
		animation.play("walk")
		
	elif current_action == Action.IDLE:
		velocity.x = 0
		animation.play("default")
	move_and_slide()
