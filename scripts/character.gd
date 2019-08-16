extends Node2D

export(String, FILE, '*tscn') var projectile_scene_path
export(String, FILE, '*tscn') var plant_scene_path
export(String, FILE, '*tscn') var hook_scene_path

export var movement_speed = 50
export var max_crop_count = 15
export var health = 5
var crops_available_count = 15

var projectile: Node2D = null
var hook: WeakRef = null

var big_cursor = load("res://assets/big_cursor.png")
var small_cursor = load("res://assets/small_cursor.png")

var impulse = Vector2.ZERO
var impulse_unfolded = 100.0
export var dampening = 300.0
var is_invulnerable = false
var original_modulate
var can_shoot
signal shot

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	
	can_shoot = true
	
	$DamageInvulnerableTimer.connect('timeout', self, 'set_invulnerability', [false])
	original_modulate = $KinematicBody2D/Sprite.modulate

func set_invulnerability(b):
	is_invulnerable = b
	
	if is_invulnerable == false:
		$KinematicBody2D/Sprite.modulate = original_modulate
		
	

func point_gun():
	$KinematicBody2D/Gun.look_at(get_global_mouse_position())
	if $KinematicBody2D.global_position.y > get_global_mouse_position().y:
		$KinematicBody2D/Gun/Sprite.z_index = 100
	else:
		$KinematicBody2D/Gun/Sprite.z_index = 101
		
	if $KinematicBody2D/Gun.global_position.x < get_global_mouse_position().x:
		$KinematicBody2D/Gun/Sprite.flip_v = false
	else:
		$KinematicBody2D/Gun/Sprite.flip_v = true

func _physics_process(delta):
	point_gun()
	
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed('left'):
		velocity.x = -movement_speed
		$KinematicBody2D/Sprite.flip_h = true
		if Input.is_action_pressed('up'):
			velocity.y = -movement_speed
			$KinematicBody2D/Sprite.animation = 'walking_up_diagonal'
		elif Input.is_action_pressed('down'):
			velocity.y = movement_speed
			$KinematicBody2D/Sprite.animation = 'walking_diagonal'
		else:
			$KinematicBody2D/Sprite.animation = 'walking'
	elif Input.is_action_pressed('right'):
		velocity.x = movement_speed
		$KinematicBody2D/Sprite.flip_h = false
		if Input.is_action_pressed('up'):
			velocity.y = -movement_speed
			$KinematicBody2D/Sprite.animation = 'walking_up_diagonal'
		elif Input.is_action_pressed('down'):
			velocity.y = movement_speed
			$KinematicBody2D/Sprite.animation = 'walking_diagonal'
		else:
			$KinematicBody2D/Sprite.animation = 'walking'
	elif Input.is_action_pressed('up'):
		velocity.y = -movement_speed
		$KinematicBody2D/Sprite.animation = 'walking_up'
	elif Input.is_action_pressed('down'):
		velocity.y = movement_speed
		$KinematicBody2D/Sprite.animation = 'idle'
	
	var movement = velocity.normalized() * delta * movement_speed
	
	if impulse_unfolded > 0:
		impulse_unfolded -= dampening * delta
		movement += impulse * (impulse_unfolded / 100)
	
	$KinematicBody2D.move_and_slide(movement)

func shoot(knockback_amount=100):
	var bodies_in_gun_range = $KinematicBody2D/Gun/GunRange.get_overlapping_bodies()
	var enemies_in_gun_range = []
	for body in bodies_in_gun_range:
		print(body.get_parent().get_name())
		if body.get_parent().is_in_group('enemies'):
			body.get_parent().damage()
	
	push_away_from_position(get_global_mouse_position(), knockback_amount)
	
	emit_signal('shot')
	$KinematicBody2D/Gun/ShotgunSound.play()
	can_shoot = false
	Input.set_custom_mouse_cursor(big_cursor)
	$KinematicBody2D/Particles2D.emitting = true
	$KinematicBody2D/Particles2D.global_position = $KinematicBody2D/Gun/Position2D.global_position
	$KinematicBody2D/Particles2D.rotation = $KinematicBody2D/Gun.rotation
	$ReloadTimer.start()

func damage(amount):
	if is_invulnerable:
		return
		
	health -= amount

	if health <= 0:
		get_tree().quit()
	
	$KinematicBody2D/Sprite.modulate = Color(1, .5, .5, 1)
	
	is_invulnerable = true
	$DamageInvulnerableTimer.start()
		


func _input(event):
	if event.is_action_released('shoot'):
		print('location: ', $KinematicBody2D.global_position)
		if can_shoot:
			shoot()
	if event.is_action_released('hook') and (hook == null or !hook.get_ref()):
		hook = weakref(load(hook_scene_path).instance())
		hook.get_ref().connect('hooked', self, 'push_to_hook', [hook.get_ref().get_node('KinematicBody2D')])
		add_child(hook.get_ref())
		hook.get_ref().global_position = $KinematicBody2D.global_position

func push_to_hook(hook: KinematicBody2D):
	var distance = hook.global_position.distance_to($KinematicBody2D.global_position)
	push_to_position(hook.global_position, distance * 7)

func push_to_position(target_position: Vector2, speed: float):
	var projectile_direction = (target_position - $KinematicBody2D.global_position).normalized()
	impulse_unfolded = 100
	impulse = projectile_direction * speed
	
func push_away_from_position(target_position: Vector2, speed: float):
	var projectile_direction = ($KinematicBody2D.global_position-target_position).normalized()
	impulse_unfolded = 100
	impulse = projectile_direction * speed

func _on_GunRange_body_exited(body):
	if body.get_parent().get_name() == 'Projectile':
		body.get_parent().queue_free()

func _on_ReloadTimer_timeout():
	can_shoot = true	
	Input.set_custom_mouse_cursor(small_cursor)
