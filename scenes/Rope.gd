extends Area2D

var hook
var player

func _ready():
	hook = get_parent().get_node('KinematicBody2D')
	player = get_parent().get_parent().get_node('KinematicBody2D')

	set_process(true)

func _process(delta):
	update()

func _draw():
	var fromTransform = hook.get_global_transform_with_canvas().origin
	var toTransform = player.get_global_transform_with_canvas().origin
	var from = Vector2(fromTransform.x, fromTransform.y)
	var to = Vector2(toTransform.x, toTransform.y)
	draw_line(from, to, Color.brown, 5)
	
