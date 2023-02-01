extends Node
class_name State_Node

@onready var state_manager:State_Manager = get_tree().get_first_node_in_group("State Manager")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
func switch_state(previous_state:State_Node,next_state:State_Node):
	previous_state.exit_state()
	next_state.enter_state()
	pass

func enter_state():
	_on_enter_state()
	pass
func exit_state():
	_on_exit_state()

func _on_enter_state():
	pass
func _on_exit_state():
	pass
func process_state(delta):
	_on_process_state(delta)
func _on_process_state(delta):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
