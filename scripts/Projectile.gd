extends Node2D

export var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	$AnimationPlayer.play('SpinProjectile')
	
	$DieTimer.connect('timeout', self, 'queue_free')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$KinematicBody2D.move_and_slide(velocity*delta)