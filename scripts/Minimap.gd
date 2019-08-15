extends Node2D

export var offset = 32
export var tile_size = 16
export var target_width = 160
export var alpha = 0.6

var character: Node2D

var origin: Vector2
var scene_size: Vector2
var map_size: Vector2
var map_rect: Rect2

func _ready():
	var terrain = get_parent().get_parent().get_node("TileMapTerrain")
	var rect = terrain.get_used_rect()
	
	var scene_width = rect.size.x * tile_size
	var scene_height = rect.size.y * tile_size
	
	var ratio = scene_width / target_width
	
	var width = scene_width / ratio
	var height = scene_height / ratio
	
	var root_node = get_parent().get_parent()
	character = root_node.get_node("Character").get_node("KinematicBody2D")
	
	origin = Vector2(offset, offset)
	scene_size = Vector2(scene_width, scene_height)
	map_size = Vector2(width, height)
	map_rect = Rect2(origin, map_size)
	
	modulate.a = alpha

func _process(delta):
	update()

func _draw():
	draw_rect(map_rect, Color.black)
	draw_circle(instanceOffset(character), 6.0, Color.forestgreen)

	for plant in get_tree().get_nodes_in_group('plant'):
		if plant.pickable: 
			draw_circle(instanceOffset(plant), 6.0, Color.purple)

func instanceOffset(instance: Node2D) -> Vector2:
	var x = ((scene_size.x - instance.global_position.x) / scene_size.x) * map_size.x
	var y = ((scene_size.y - instance.global_position.y) / scene_size.y) * map_size.y
	return origin + map_size - Vector2(x, y)
