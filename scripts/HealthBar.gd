extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var original_scale = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var character_node = get_tree().get_root().get_node('Node2D/Character')
	character_node.connect('damaged', self, 'set_health', [character_node])
#	original_scale = self.get_scale()
#	$GrowEffect.interpolate_property(
#		self,
#		'scale',
#		self.get_scale(),
#		Vector2(1.0, 1.0),
#		0.1,
#		Tween.TRANS_CUBIC,
#		Tween.EASE_OUT 
#	)
#	$GrowEffect.connect('tween_all_completed', self, 'set_original_scale')
	
#	$ShrinkEffect.interpolate_property(
#		self,
#		'scale',
#		self.get_scale(),
#		original_scale,
#		0.1,
#		Tween.TRANS_CUBIC,
#		Tween.EASE_OUT 
#	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_health(character):
	frame = character.health-1
#	$GrowEffect.start()
	
