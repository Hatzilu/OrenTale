extends TextureProgressBar

var player: Player

func _ready():
	player.set_hp.connect(update)

func update(new_value):
	value = new_value
