extends Node2D

export var max_plant_index = 4
export var random_grow_time = false
export var start_sprite_position = Vector2(14, 448)

# Plant sprite locations.
const TOMATO 		= Rect2(Vector2(14, 448), Vector2(16, 16))
const STRAWBERRY 	= Rect2(Vector2(14, 464), Vector2(16, 16))
const POTATO 		= Rect2(Vector2(14, 480), Vector2(16, 16))
const LETTUCE 		= Rect2(Vector2(14, 496), Vector2(16, 16))
const EGGPLANT 		= Rect2(Vector2(14, 512), Vector2(16, 16))
const GREEN_GRAPE 	= Rect2(Vector2(14, 528), Vector2(16, 16))
const TURNIP 		= Rect2(Vector2(80, 448), Vector2(16, 16))
const PUMPKIN 		= Rect2(Vector2(80, 464), Vector2(16, 16))
const CARROT 		= Rect2(Vector2(80, 480), Vector2(16, 16))
const CAULIFLOWER 	= Rect2(Vector2(80, 496), Vector2(16, 16))
const WATERMELON 	= Rect2(Vector2(80, 512), Vector2(16, 16))
const RED_GRAPE 	= Rect2(Vector2(80, 528), Vector2(16, 16))
var plant_index = 0
var pickable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$GrowTimer.connect('timeout', self, 'grow_plant')
	
	if random_grow_time:
		$GrowTimer.wait_time = randi()%3+1
	
	var random_plant_sprite = [TOMATO, STRAWBERRY, POTATO, LETTUCE, EGGPLANT, GREEN_GRAPE, TURNIP, PUMPKIN, CARROT, CAULIFLOWER, WATERMELON, RED_GRAPE][randi()%12]
	for i in range(4):
		get_node('Sprite'+str(i)).region_rect.position = Vector2(random_plant_sprite.position.x+(16*i), random_plant_sprite.position.y)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func grow_plant():
	if plant_index == max_plant_index-1:
		return
		
	get_node('Sprite' + str(plant_index)).visible = false
	plant_index += 1
	get_node('Sprite' + str(plant_index)).visible = true
	
	if plant_index == max_plant_index-1:
		$GrowTimer.stop() 
		pickable = true
	
	var current_sprite = get_node('Sprite'+str(plant_index))
	$PickEffect.interpolate_property(
		current_sprite,
		'scale',
		current_sprite.get_scale(),
		Vector2(2.0, 2.0),
		0.3,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT 
	)

func _on_PickArea_body_entered(body):
	if body.get_parent().get_name() == 'Character':
		if pickable:
			get_node('Sprite'+str(plant_index)).z_index = 200
			$PickEffect.start()

func _on_PickEffect_tween_completed(object, key):
	queue_free()
