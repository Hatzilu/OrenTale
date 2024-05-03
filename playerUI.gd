extends Control

@onready var player = $"../../Player"
@onready var hp_bar = $HP

# Called when the node enters the scene tree for the first time.
func _ready():
	player.on_hp_changed.connect(update_hp) 
	hp_bar.value = player.hp

func update_hp(v):
	print("v is %s" % v)
	print("hpbar value is %s" % hp_bar.value)
	hp_bar.value = v

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	#
#func update_hp_bar(new_value):
	#hp_bar.value = new_value
	#()
