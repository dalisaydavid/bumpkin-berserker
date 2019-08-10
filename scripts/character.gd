extends Node2D

export(String, FILE, '*tscn') var projectile_scene_path
export(String, FILE, '*tscn') var plant_scene_path
export var movement_speed = 50
var velocity = Vector2(0,0)

var impulse = Vector2.ZERO
var scaled = 100.0
export var dampening = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_action_pressed('left'):
		velocity.x = -movement_speed
		$KinematicBody2D/Sprite.flip_h = true
		$KinematicBody2D/Sprite.animation = 'walking'
	elif Input.is_action_pressed('right'):
		velocity.x = movement_speed
		$KinematicBody2D/Sprite.flip_h = false
		$KinematicBody2D/Sprite.animation = 'walking'
	if Input.is_action_pressed('up'):
		velocity.y = -movement_speed
		$KinematicBody2D/Sprite.animation = 'walking_up'
	elif Input.is_action_pressed('down'):
		velocity.y = movement_speed
		$KinematicBody2D/Sprite.animation = 'idle'
	#else:
	#	$KinematicBody2D/Sprite.animation = 'idle'
	
	var movement = velocity * delta
	
	if scaled > 0:
		scaled -= dampening
		movement += impulse * (scaled / 100)
	
	$KinematicBody2D.move_and_slide(movement)

func _input(event):
	if event.is_action_released('shoot'):
		impulse = Vector2(200, 500)
		scaled = 100
#		var projectile = load(projectile_scene_path).instance()
#		add_child(projectile)
#		projectile.global_position = $KinematicBody2D.global_position
	if event.is_action_released('plant'):
		var plant = load(plant_scene_path).instance()
		add_child(plant)
		plant.global_position = $KinematicBody2D.global_position
		