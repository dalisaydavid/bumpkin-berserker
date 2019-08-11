extends Node2D

export var speed = 10000
var direction
signal hooked

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	
	direction = (get_global_mouse_position() - get_parent().get_node('KinematicBody2D').global_position).normalized()

func _physics_process(delta):
	$KinematicBody2D.move_and_slide(direction*delta*speed)

func _on_Area2D_body_entered(body):
	if body.get_name() == 'TileMapBoundaries':
		emit_signal('hooked')
		queue_free()
