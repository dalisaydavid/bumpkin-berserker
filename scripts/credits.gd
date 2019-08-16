extends Control

var scene_path_to_load
var arrow = load("res://assets/small_cursor.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow)

func _on_FadeIn_fade_finished():
	if scene_path_to_load == 'exit':
		get_tree().quit()
	else:
		get_tree().change_scene(scene_path_to_load)

func _on_LeftButton_pressed():
	var button = $LeftButton
	scene_path_to_load = button.scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()
