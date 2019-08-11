extends Node2D

export(String, FILE, '*tscn') var projectile_scene_path
export(String, FILE, '*tscn') var plant_scene_path
export(String, FILE, '*tscn') var hook_scene_path
export var movement_speed = 50

var projectile: Node2D = null
var hook: WeakRef = null

var impulse = Vector2.ZERO
var impulse_unfolded = 100.0
export var dampening = 300.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$KinematicBody2D/Gun.look_at(get_global_mouse_position())
#	$KinematicBody2D/Gun/Sprite.rotate(45)
	
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed('left'):
		velocity.x = -movement_speed
		$KinematicBody2D/Sprite.flip_h = true
		#$KinematicBody2D/Sprite.animation = 'walking'
	elif Input.is_action_pressed('right'):
		velocity.x = movement_speed
		$KinematicBody2D/Sprite.flip_h = false
		#$KinematicBody2D/Sprite.animation = 'walking'
	if Input.is_action_pressed('up'):
		velocity.y = -movement_speed
		#$KinematicBody2D/Sprite.animation = 'walking_up'
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

func shoot():
	var bodies_in_gun_range = $KinematicBody2D/Gun/Sprite/GunRange.get_overlapping_bodies()
	var enemies_in_gun_range = []
	for body in bodies_in_gun_range:
		if body.get_parent().is_in_group('enemies'):
			body.get_parent().queue_free()
			
#	projectile = load(projectile_scene_path).instance()
#	add_child(projectile)
#	projectile.global_position = $KinematicBody2D/Gun.global_position

func _input(event):
	if event.is_action_released('shoot'):
		shoot()
	if event.is_action_released('plant'):
		var plant = load(plant_scene_path).instance()
		add_child(plant)
		plant.global_position = $KinematicBody2D.global_position
	if event.is_action_released('hook') and (hook == null or !hook.get_ref()):
		hook = weakref(load(hook_scene_path).instance())
		hook.get_ref().connect('hooked', self, 'push_to_hook', [hook.get_ref().get_node('KinematicBody2D')])
		add_child(hook.get_ref())
		hook.get_ref().global_position = $KinematicBody2D.global_position

func push_to_hook(hook: KinematicBody2D):
	var distance = hook.global_position.distance_to($KinematicBody2D.global_position)
	push_to_instance(hook, distance * 8)

func push_to_instance(instance: KinematicBody2D, speed: float):
	var projectile_direction = (instance.global_position - $KinematicBody2D.global_position).normalized()
	impulse_unfolded = 100
	impulse = projectile_direction * speed

func _on_GunRange_body_exited(body):
	if body.get_parent().get_name() == 'Projectile':
		body.get_parent().queue_free()
