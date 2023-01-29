extends Node
class_name State_Manager

@export var auto_start:bool=true
var state_manager_started:bool=false
var active_state:State_Node
var enemy_controller:Enemy_Controller
# Called when the node enters the scene tree for the first time.
func _ready():
	active_state=get_child(0)
	if auto_start:
		start_state_manager()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state_manager_started:
		active_state.process_state(delta)
	pass
func start_state_manager():
	active_state.state_manager=self
	active_state.enter_state()
	
	state_manager_started=true
	pass
