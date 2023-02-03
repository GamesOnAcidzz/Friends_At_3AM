extends Node
class_name State_Manager

@export var auto_start:bool=true

var state_manager_started:bool=false
var active_state:State_Node
var ai_controller:AI_Controller

@onready var state_machine_tree:State_Machine_Tree = get_parent()
@onready var initial_state:State_Node = get_child(0)
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if auto_start:
		start_state_manager()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state_manager_started:
		active_state.process_state(delta)
	pass
func start_state_manager():
	active_state=initial_state
	active_state.state_manager=self
	active_state.enter_state()
	state_manager_started=true
	pass
func restart_state_manager():
	for state_node in get_children(true):
		state_node._on_restart_tree()
	initial_state.enter_state()
