extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var character_node = get_tree().get_root().get_node('Node2D/Character')
	character_node.connect('damaged', self, 'set_health', [character_node])

func set_health(character):
	for i in range(5):
		if character.health > i:
			get_node('Heart'+str(i)).region_rect = Rect2(Vector2(16, 0), Vector2(16, 16))
		else:
			get_node('Heart'+str(i)).region_rect = Rect2(Vector2(32, 0), Vector2(16, 16))
