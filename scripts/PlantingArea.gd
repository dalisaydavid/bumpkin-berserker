extends Node2D

var increasing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if increasing:
		$Area2D/CollisionShape2D/ProgressBar.value += 1

func _on_Area2D_body_entered(body):
	print("In")
	if body.get_parent().get_name() == 'Character':
		increasing = true

func _on_Area2D_body_exit(body):
	print("Out")
	if body.get_parent().get_name() == 'Character':
		increasing = false
