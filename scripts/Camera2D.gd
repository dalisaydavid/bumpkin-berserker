extends Camera2D

export var shake_on = false
export var shake_amount = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	
	get_parent().get_node('Character').connect('shot', self, 'start_shake')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_parent().get_node('Character').get_node('KinematicBody2D').global_position
	
	if shake_on:
		shake()

func start_shake():
	shake_on = true
	$ShakeTimer.start()
	
func shake():
	if shake_on:
		self.set_offset(Vector2( \
			rand_range(-1.0, 1.0) * shake_amount, \
			rand_range(-1.0, 1.0) * shake_amount \
		))

func _on_ShakeTimer_timeout():
	shake_on = false
