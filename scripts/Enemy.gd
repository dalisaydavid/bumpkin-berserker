extends Node2D

export var move_speed = 50

var velocity
var is_dead = false
var path = null 
var root_node
var character_node

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	
	$AnimationPlayer.play('Idle')
	
	root_node = get_tree().get_root().get_node('Node2D')
	character_node = root_node.get_node('Character')
	
	move_speed = randi()%50+25

#func change_direction():
#	var animation = 'Idle'
#
#	if velocity.x < 0: # walking left.
#		$KinematicBody2D/Sprite.flip_h = true
#	else: #walking right
#		$KinematicBody2D/Sprite.flip_h = false
#
#	if velocity.y > 0: # walking down
#		animation = 'walking_down_diagonal'
#	elif velocity.y < 0:
#		animation = 'walking_up_diagonal'
#	else:
#		animation = 'walking_side'
#	$AnimationPlayer.play(animation)

func damage():
	queue_free()
#	is_dead = true
#	$AnimationPlayer.play('Dead')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dead:
		return
		
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
	
	var target = null
	if $Earshot.overlaps_body(character_node.get_node('KinematicBody2D')):
		target = character_node.get_node('KinematicBody2D')
		
	target = get_closest_planting_area()
	# @TODO: Make closest plant function performant :(
	var closest_plant = get_closest_pickable_plant(target)
	if closest_plant:
		target = closest_plant

	var new_path = root_node.get_node('Navigation2D').get_simple_path(global_position, target.global_position)
	set_path(new_path)

func get_closest_pickable_plant(planting_area):
	var min_distance = INF
	var min_plant = null
	for plant in planting_area.get_children():
		if plant.get_name() == 'Area2D':
			continue
			
		if not plant.pickable:
			continue
		var distance = global_position.distance_to(plant.global_position)
		if distance < min_distance:
			min_distance = distance
			min_plant = plant
	
	return min_plant

func get_closest_planting_area():
	var min_distance = INF
	var min_planting_area = null
	for planting_area in root_node.get_node('PlantingAreas').get_children():
		var distance = global_position.distance_to(planting_area.global_position)
		if distance < min_distance:
			min_distance = distance
			min_planting_area = planting_area
	
	return min_planting_area
			
				
func set_path(new_path):
	path = new_path
	if path.size() == 0:
		return


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'Dead':
		queue_free()
