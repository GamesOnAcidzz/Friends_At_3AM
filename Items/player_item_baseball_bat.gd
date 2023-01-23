extends Player_item


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _onPrimary_action():
	player_onwer.animation_controller["parameters/Basic Player Control/BlendTree/Baseball_bat/playback"].travel("Swing_bat")
	pass
