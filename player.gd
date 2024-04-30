extends CharacterBody2D


@export var max_hp = 100
@export var hp = max_hp

@export var max_mp = 25
@export var mp = max_mp

@export var SPEED = 75
@export var JUMP_VELOCITY = -400.0

# Triggers when a player gets hurt, so it won't get repeatedly hurt over and over too fast
@onready var blink_timer = $HurtTimer

const MAX_BLINKS = 5
const BLINK_DURATION = 0.25
var blinks_left = MAX_BLINKS

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_attacking = false

var flinch_velocity: Vector2


#func _process(delta):
	#if blinks_left > 0 && blink_timer.:
		#invincible_duration -= 1 * delta

func _physics_process(delta):
	
	# if the player was hurt in  the last frame, apply knockback
	if flinch_velocity != Vector2.ZERO:
		velocity = flinch_velocity

		flinch_velocity.x = move_toward(flinch_velocity.x,0,SPEED * 10 * delta)
		flinch_velocity.y = move_toward(flinch_velocity.y,0,SPEED * 10 * delta)

		move_and_slide()
		return
		
	# handle attack logic
	if Input.is_action_pressed("Attack"):
		is_attacking = true
		sprite_2d.animation = "attack"
	else:
		is_attacking = false
	
	# set  animations according to velocity
	if is_on_floor() && velocity.x != 0:
		sprite_2d.animation = "walk"
	else:
		sprite_2d.animation = "default"
		
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jump"
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 50)

	# flip the sprite according to the direction
	if direction == -1:
		sprite_2d.flip_h = true
	if direction == 1:
		sprite_2d.flip_h = false
	move_and_slide()


func take_damage(amount: int):
	hp -= amount
	print("Player took %s dmg" % hp)
	if hp <= 0: 
		print("Player is dead")

func _on_hurtbox_body_entered(body):
	if !body.is_in_group("Enemies"):
		return
	print("Damage: %s" % body.damage)
	
	var damage = body.damage
	if blink_timer.is_stopped():
		take_damage(damage)
		blink_timer.start(BLINK_DURATION)
		
		#move the character back according to the direction in which it was hit from
		var h_direction = body.position.direction_to(global_position)
		set_collision_layer_value(0,false)
		flinch_velocity = Vector2(damage*100*h_direction.x, damage*100*h_direction.y);


func _on_hurt_timer_timeout():
	
	if blinks_left % 2 != 0:
		set_modulate(Color(10,10,10,0.9))
	else:
		set_modulate(Color(1,1,1,1))
		
	if blinks_left > 0: 
		print("Blinks left: %s" % blinks_left)
		blinks_left -= 1
		blink_timer.start(BLINK_DURATION)
		return
		
	blinks_left = MAX_BLINKS
	blink_timer.stop()
	set_modulate(Color(1,1,1,1))
	set_collision_layer_value(0,true)
