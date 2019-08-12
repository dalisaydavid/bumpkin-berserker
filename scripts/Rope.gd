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
	var from = Vector2.ZERO
	var to = player.global_position - hook.global_position
	draw_line(from, to, Color.beige, 2)
