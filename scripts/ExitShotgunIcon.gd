extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ExitGameButton_focus_entered():
	visible = true

func _on_ExitGameButton_focus_exited():
	visible = false


func _on_ExitGameButton_mouse_entered():
	get_parent().grab_focus()
	visible = true
