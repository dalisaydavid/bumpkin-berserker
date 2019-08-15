extends Control

onready var left_effect = get_node("LeftButton/Bounce")
onready var left_sprite = get_node("LeftButton")	
onready var right_effect = get_node("RightButton/Bounce")
onready var right_sprite = get_node("RightButton")


# Called when the node enters the scene tree for the first time.
func _ready():
	right_sprite.grab_focus()
	_start_tweens()

func _start_tweens():
	
	var dis = 5
	var left_pos = left_sprite.get_position()
	var left_new_pos = Vector2(left_pos[0] - dis, left_pos[1])
	
	left_effect.interpolate_property(
		left_sprite,
		'rect_position',
		left_pos,
		left_new_pos,
		.65,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	
	var right_pos = right_sprite.get_position()
	var right_new_pos = Vector2(right_pos[0] + dis, right_pos[1])
	
	right_effect.interpolate_property(
		right_sprite,
		'rect_position',
		right_pos,
		right_new_pos,
		.65,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)

	left_effect.start()
	right_effect.start()
	
	return

func _on_LeftButton_pressed():
	get_tree().change_scene($LeftButton.scene_to_load)
	
func _on_RightButton_pressed():
	get_tree().change_scene($RightButton.scene_to_load)
