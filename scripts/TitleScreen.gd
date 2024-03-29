extends Control

var scene_path_to_load
var arrow = load("res://assets/small_cursor.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow)
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect('pressed', self, '_on_Button_pressed', [button.scene_to_load])
	pass # Replace with function body.

func _on_Button_pressed(scene_to_load):
	$ShotgunSound.play()
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
	if scene_path_to_load == 'exit':
		get_tree().quit()
	else:
		get_tree().change_scene(scene_path_to_load)