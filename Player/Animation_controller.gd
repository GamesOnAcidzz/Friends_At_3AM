extends AnimationTree
@onready var player_controller:Player_controller = get_parent()
@onready var state_machine = self["parameters/playback"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player_controller.is_running:
		state_machine.travel("Basic Player Control")
		set("parameters/Basic Player Control/BlendTree/BlendSpace2D/blend_position",player_controller.input_dir)
	else:
		state_machine.travel("Run")
	pass
