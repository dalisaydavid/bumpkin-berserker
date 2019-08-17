extends Node2D

export(String, FILE, '*tscn') var plant_scene_path

export var plant_speed = 35

enum State {
	empty,
	growing,
	done,
	dead
}

var character: Node2D
var progress_bar: Node
var last_plant: Node2D
var plants = []
var farm_state

# Called when the node enters the scene tree for the first time.
func _ready():
	character = get_parent().get_parent().get_node("Character").get_node("KinematicBody2D")
	progress_bar = $Area2D/CollisionShape2D/ProgressBar
	farm_state = State.empty
	
	progress_bar.modulate.a = 0

func can_progress():
	for enemy in get_tree().get_nodes_in_group('enemies'):
		if $Area2D.overlaps_body(enemy.get_node('KinematicBody2D')):
			return false
			
	return true
	

func _process(delta):
	
	if farm_state == State.empty:
		if not can_progress():
			return
			
		if $Area2D.overlaps_body(character):
			progress_bar.value += plant_speed * delta
			progress_bar.modulate.a = 1
		else:
			progress_bar.modulate.a -= 1 * delta
			if progress_bar.modulate.a <= 0:
				progress_bar.value = 0
			
		if progress_bar.value >= 100:
			plant()
			progress_bar.modulate.a = 0
			progress_bar.value = 0
			farm_state = State.growing
	
	elif farm_state == State.growing:
		if last_plant.pickable:
			farm_state = State.done
	
	elif farm_state == State.done:
		for node in get_children():
			if node.is_in_group("plant"):
				return
			
		farm_state = State.empty
	
func plant():
	var plant_spots = [-.70, -.35, 0, .35, .70]
	var width = $Area2D/CollisionShape2D.shape.extents.x
	var height = $Area2D/CollisionShape2D.shape.extents.y
	
	plants = []
	for spot_v in plant_spots:
		for spot_h in plant_spots:
				var rel = Vector2(width * spot_h, height * spot_v)
				last_plant = load(plant_scene_path).instance()
				add_child(last_plant)
				plants.append(last_plant)
				last_plant.global_position = $Area2D.global_position + rel
