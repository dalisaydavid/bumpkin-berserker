extends Node2D

export var move_speed = 50

var velocity
var is_dead = false
var path = null 
var root_node
var character_node

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	
	$AnimationPlayer.play('Idle')
	
	root_node = get_tree().get_root().get_node('Node2D')
	character_node = root_node.get_node('Character')

func change_direction():
	var animation = 'Idle'
	
	if velocity.x < 0: # walking left.
		$KinematicBody2D/Sprite.flip_h = true
	else: #walking right
		$KinematicBody2D/Sprite.flip_h = false
	
	if velocity.y > 0: # walking down
		animation = 'walking_down_diagonal'
	elif velocity.y < 0:
		animation = 'walking_up_diagonal'
	else:
		animation = 'walking_side'
	$AnimationPlayer.play(animation)

func damage():
	is_dead = true
	$AnimationPlayer.play('Dead')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	if path:
		var distance = move_speed * delta
		var start_point = position
		for i in range(path.size()):
			var distance_to_next = start_point.distance_to(path[0])
			if distance <= distance_to_next and distance >= 0.0:
				position = start_point.linear_interpolate(path[0], distance/distance_to_next)
				break
			elif distance < 0.0:
				position = path[0]
				path = null
				break
			distance -= distance_to_next
			start_point = path[0]
			path.remove(0)
	
	
	if $Earshot.overlaps_body(character_node.get_node('KinematicBody2D')):
		var new_path = root_node.get_node('Navigation2D').get_simple_path(get_node('KinematicBody2D').global_position, character_node.get_node('KinematicBody2D').global_position)
		root_node.get_node('Line2D').points = new_path
		set_path(new_path)
				
func set_path(new_path):
	path = new_path
	if path.size() == 0:
		return

func _on_AnimationPlayer_animation_finished(anim_name):
	pass


func _on_Earshot_body_entered(body):
	pass

