extends CharacterBody2D


@onready var animation = $AnimatedSprite2D
@onready var detection_area = $Area2D
@export var SPEED = 300
@export var move_dir: Vector2

@export var health = 5

@export var damage = 5

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
var target: CharacterBody2D

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
		
	# If the mob is aggroed, just move towards the player
	if target && aggro_timer > 0:
		var direction = global_position.direction_to(target.position)
		velocity.x = direction.x * SPEED * delta
		animation.flip_h = direction.x < 0
		move_and_slide()
		return
		
	elif current_action == Action.MOVE_LEFT:
		velocity.x = SPEED * delta
		animation.flip_h = false
		animation.play("walk")
		
	elif current_action == Action.MOVE_RIGHT:
		velocity.x = (SPEED * delta) * (-1)
		animation.flip_h = true
		animation.play("walk")
		
	elif current_action == Action.IDLE:
		velocity.x = move_toward(velocity.x, 0, 50)
		animation.play("default")
	move_and_slide()

# this is the logic for if the area2D detects a player, AKA mob "aggro"
func _on_area_2d_body_entered(body):
	if !body.is_in_group("Players"):
		return
	aggro_timer = AGGRO_DURATION_SECONDS
	#var n = body.get_node()
	target = body
