extends Node2D

export(String, FILE, '*tscn') var projectile_scene_path
export(String, FILE, '*tscn') var plant_scene_path
export var movement_speed = 50

var projectile: Node2D = null

var impulse = Vector2.ZERO
var impulse_unfolded = 100.0
export var dampening = 300.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector2.ZERO
	
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
	
	if impulse_unfolded > 0:
		impulse_unfolded -= dampening * delta
		movement += impulse * (impulse_unfolded / 100)
	
	$KinematicBody2D.move_and_slide(movement)

func _input(event):
	if event.is_action_released('shoot'):
		projectile = load(projectile_scene_path).instance()
		add_child(projectile)
		projectile.global_position = $KinematicBody2D.global_position
	if event.is_action_released('plant'):
		var plant = load(plant_scene_path).instance()
		add_child(plant)
		plant.global_position = $KinematicBody2D.global_position
	if event.is_action_released('hook'):
		if projectile != null:
			push_to_instance(projectile.get_node("KinematicBody2D"), 500)
		
func push_to_instance(instance: KinematicBody2D, speed: float):
	var projectile_direction = (instance.global_position - $KinematicBody2D.global_position).normalized()
	impulse_unfolded = 100
	impulse = projectile_direction * speed
	