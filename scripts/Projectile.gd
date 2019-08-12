extends Node2D

export var velocity = Vector2(0,0)
export var speed = 500
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	$AnimationPlayer.play('SpinProjectile')
	
	$DieTimer.connect('timeout', self, 'queue_free')
	
	# direction = (get_global_mouse_position() - get_parent().get_node('KinematicBody2D').global_position).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
#	$KinematicBody2D.move_and_slide(velocity*delta)
#	var collision = $KinematicBody2D.move_and_collide(direction*delta*speed)
#	if collision:
#		print(collision.collider.get_parent().get_name())
#		if collision.collider.get_parent().is_in_group('enemies'):
#			collision.collider.get_parent().queue_free()
#		queue_free()
