extends Area2D

export(String, FILE, '*tscn') var plant_scene_path
export var number_of_random_plants = 3

var center_position
var size

func _ready():
	center_position = $CollisionShape2D.position + position
	size = $CollisionShape2D.shape.extents

	for i in range(number_of_random_plants):
		place_random_plant()

func get_random_position():
	var random_x = (randi() % int(size.x)) - (size.x/2) + center_position.x
	var random_y = (randi() % int(size.y)) - (size.y/2) + center_position.y
	
	return Vector2(random_x, random_y)

func place_random_plant():
	var plant = load(plant_scene_path).instance()
	add_child(plant)
	plant.global_position = get_random_position()