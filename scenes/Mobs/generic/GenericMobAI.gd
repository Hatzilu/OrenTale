extends CharacterBody2D


@onready var animation = $AnimatedSprite2D
@onready var detection_area = $Area2D
@onready var aggro_timer = $AggroTimer
@onready var action_timer = $ActionTimer

@export var SPEED = 300
@export var move_dir: Vector2

@export var health = 5

@export var damage = 5

const ACTION_DURATION_SECONDS = 5
const AGGRO_DURATION_SECONDS = 10

var current_action: int

#var time_until_next_action = ACTION_DURATION_SECONDS

var Action = {
	IDLE = 0,
	MOVE_LEFT = 1,
	MOVE_RIGHT = 2
}

# This is the position of the player that aggro'd the mob, if it's nil, then there's no aggro
var target: CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _handle_action():
	var new_action = randi() % Action.size()
	current_action = new_action

func _ready():
	current_action = Action.IDLE
	

func _physics_process(delta):
	#if is_on_floor() && velocity.x != 0:
		#sprite_2d.animation = "walk"
	#else:
		#sprite_2d.animation = "default"
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# If the mob is aggroed, just move towards the player
	if target:
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
	aggro_timer.start(AGGRO_DURATION_SECONDS)
	action_timer.stop()
	target = body


func _on_aggro_timer_timeout():
	print("Aggro expired")
	target = null
	if action_timer.is_stopped():
		action_timer.start(ACTION_DURATION_SECONDS)


func _on_action_timer_timeout():
	_handle_action()
	print("New action: %s" % current_action)
	action_timer.start(ACTION_DURATION_SECONDS)
