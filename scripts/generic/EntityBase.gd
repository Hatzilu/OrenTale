extends CharacterBody2D

@export var max_hp = 100;
@export var hp = max_hp;

@export var max_mp = 25;
@export var mp = max_mp;

@export var SPEED = 75

@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var animation_player = $AnimationPlayer



func _physics_process(delta):
	pass
	
func move():
	move_and_slide()
	
func die():
	queue_free()
