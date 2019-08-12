extends Node2D

export var speed = 24000
var direction
var returning = false
signal hooked

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	
	direction = (get_global_mouse_position() - get_parent().get_node('KinematicBody2D').global_position).normalized()
	$KinematicBody2D/Sprite.rotation = direction.angle()
	
	$ReturnTimer.connect('timeout', self, 'return_to_player')

func return_to_player():
	var parent_body: KinematicBody2D = get_parent().get_node('KinematicBody2D')
	direction = (parent_body.global_position - $KinematicBody2D.global_position).normalized()
	returning = true

func _physics_process(delta):
	if returning:
		return_to_player()
	$KinematicBody2D.move_and_slide(direction*delta*speed)

func _on_Area2D_body_entered(body):
	if body.get_name() == 'TileMapBoundaries':
		speed = 0
		returning = true
		
		emit_signal('hooked')
		
		var timer = Timer.new()
		timer.set_wait_time(0.5)
		timer.connect("timeout", self, "queue_free")
		add_child(timer)
		timer.start()
	
	if body.get_parent().get_name() == 'Character' and returning:
		queue_free()
