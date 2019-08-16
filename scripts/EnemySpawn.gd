extends Position2D

export(String, FILE, '*tscn') var enemy_scene_path

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = randi()%45+30
	$Timer.connect('timeout', self, 'spawn_enemy')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_enemy():
	var enemy = load(enemy_scene_path).instance()
	get_parent().add_child(enemy)
	enemy.global_position = self.global_position