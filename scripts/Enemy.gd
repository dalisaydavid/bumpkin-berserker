extends Node2D

export var move_speed = 50

var velocity
var is_dead = false
var path = null 
var root_node
var character_node
var bodies_in_area = []
var retarget = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	
	$AnimationPlayer.play('Idle')
	
	root_node = get_tree().get_root().get_node('Node2D')
	character_node = root_node.get_node('Character')
	
	move_speed = randi()%50+25
	
	$ContinuousAttackTimer.connect('timeout', self, 'attack_bodies_in_area')
	$PathTimer.connect('timeout', self, 'reset_retarget')

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

func attack_bodies_in_area():
	for body in bodies_in_area:
		body.get_parent().damage(1)

func reset_retarget():
	retarget = true

func damage():
	queue_free()
#	is_dead = true
#	$AnimationPlayer.play('Dead')

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
	
	if retarget:
		retarget = false
		var target = null
		var max_offset = 1
		
		if $Earshot.overlaps_body(character_node.get_node('KinematicBody2D')):
			target = character_node.get_node('KinematicBody2D')
		else:
			target = get_closest_planting_area()
			max_offset = 80
			
			var plant = get_random_pickable_plant(target)
			if plant:
				max_offset = 20
				target = plant
		
		if target:
			if target.get_name() == 'KinematicBody2D':
				move_speed = randi()%50+100
			var offset = (randi() % max_offset) - (max_offset / 2)
			var target_position = target.global_position + Vector2(offset, offset)
			var new_path = root_node.get_node('Navigation2D').get_simple_path(global_position, target_position)
			set_path(new_path)

func get_random_pickable_plant(planting_area):
	if not planting_area or planting_area.get_parent().get_name() == 'Character':
		return
	
	var plants = planting_area.plants.duplicate()
	if plants.empty():
		return null
	else:
		return plants[randi() % plants.size()]

func get_closest_pickable_plant(planting_area):
	if not planting_area:
		return null
	
	var min_distance = INF
	var min_plant = null
	for plant in planting_area.plants:
		if not plant.is_in_group('plant'):
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
		if planting_area.farm_state == planting_area.State.dead:
			continue
		
		var distance = global_position.distance_to(planting_area.global_position)
		if distance < min_distance:
			min_distance = distance
			min_planting_area = planting_area
	
	if min_planting_area == null:
		min_planting_area = character_node.get_node('KinematicBody2D')
	
	return min_planting_area
			
				
func set_path(new_path):
	path = new_path
	if path.size() == 0:
		return


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'Dead':
		queue_free()


func _on_AttackArea_body_entered(body):
	if body.get_parent().get_name() == 'Character':
		bodies_in_area.append(body)
		body.get_parent().damage(1)
	if body.get_parent().get_name().begins_with('PlantingArea'):
		print('???')
		bodies_in_area.append(body)


func _on_AttackArea_body_exited(body):
	var index = bodies_in_area.find(body)
	if index != -1:
		bodies_in_area.remove(index)
		
