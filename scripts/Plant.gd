extends Node2D

var plant_index = 0
export var max_plant_index = 4
var pickable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$GrowTimer.connect('timeout', self, 'grow_plant')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func grow_plant():
	if plant_index >= max_plant_index-1:
		$GrowTimer.stop() 
		pickable = true
		return
		
	get_node('Sprite' + str(plant_index)).visible = false
	plant_index += 1
	get_node('Sprite' + str(plant_index)).visible = true
	

func _on_PickArea_body_entered(body):
	if body.get_parent().get_name() == 'Character':
		if pickable:
			queue_free()
