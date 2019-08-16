extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root().get_node('Node2D')
	var character = root.get_node('Character')
	character.connect('shot', self, 'set_text', [character])

func set_text(character):
	self.text = str(character.kill_count)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
