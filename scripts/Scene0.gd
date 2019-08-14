extends Node2D

export var tile_size = 16
export(String, FILE, '*tscn') var plant_scene_path
export var number_of_random_plants = 0
var scene_width = null
var scene_height = null
# Called when the node enters the scene tree for the first time.
func _ready():
	var rect = $TileMapTerrain.get_used_rect()
	
	scene_width = rect.size.x * tile_size
	scene_height = rect.size.y * tile_size
	
	if number_of_random_plants > 0:
		place_random_plants(number_of_random_plants)
	
func place_random_plants(num):
	for i in range(num):
		var plant = load(plant_scene_path).instance()
		add_child(plant)
		plant.global_position = Vector2(randi()%int(scene_width), randi()%int(scene_height))
