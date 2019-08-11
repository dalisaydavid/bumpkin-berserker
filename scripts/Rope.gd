extends Area2D

var hook
var player

func _ready():
	hook = get_parent()
	player = get_parent().get_parent().get_parent().get_node('KinematicBody2D')

	set_process(true)

func _process(delta):
	update()

func _draw():
#	var fromTransform = hook.global_position - hook.get_global_transform_with_canvas().get_origin()
#	var toTransform = player.global_position - player.get_global_transform_with_canvas().get_origin()
#	var from = Vector2(fromTransform.x, fromTransform.y)
#	var to = Vector2(toTransform.x, toTransform.y)
	var from = Vector2.ZERO
	var to = player.global_position - hook.global_position
	print('from: ' + String(from) + ', to: ' + String(to))
	draw_line(from, to, Color.brown, 5)
	
