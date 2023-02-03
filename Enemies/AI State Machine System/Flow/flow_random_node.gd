extends Flow_Node
class_name Flow_Select_Node

@onready var condition_state_nodes=get_children()

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
func enter_flow():
	pass
	
func exit_flow():
	pass
	
func _on_enter_flow():
	pass
	
func _on_exit_flow():
	pass
	
func _on_enter_state():
	switch_state(self,get_child(randi_range(0,get_child_count()-1)))
	

func check_for_conditions_met():
	pass 
