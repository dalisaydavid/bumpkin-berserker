extends Control

onready var right_effect = get_node("TutorialArea/CenterBox/VBoxContainer/RightButton/Bounce")
onready var right_sprite = get_node("TutorialArea/CenterBox/VBoxContainer/RightButton")

var arrow = load("res://assets/small_cursor.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow)
	right_sprite.grab_focus()
	_start_tweens()

func _start_tweens():
	
	var dis = 5
	
	var right_size = right_sprite.get_size()
	var right_new_size = Vector2(right_size[0], right_size[1] + 5)
	
	right_effect.interpolate_property(
		right_sprite,
		'rect_size',
		right_size,
		right_new_size,
		.65,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)

	right_effect.start()
	
	return
	
func _on_RightButton_pressed():
	var button = $TutorialArea/CenterBox/VBoxContainer/RightButton
	get_tree().change_scene(button.scene_to_load)
