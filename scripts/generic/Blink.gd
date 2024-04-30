extends Timer


@onready var sprite = $AnimatedSprite2D

@export var blink_duration := 0.25
@export var number_of_blinks := 5

# This is the overall amount of time the blink should happen in
var blinks_left := number_of_blinks

func blink():
	blink_timer.start()
