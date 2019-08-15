extends Control

onready var right_effect = get_node("RightButton/Bounce")
onready var right_sprite = get_node("RightButton")

var arrow = load("res://assets/small_cursor.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow)
	right_sprite.grab_focus()
	_start_tweens()

func _start_tweens():

	var dis = 5

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

	right_effect.start()

func _on_RightButton_pressed():
	get_tree().change_scene($RightButton.scene_to_load)
