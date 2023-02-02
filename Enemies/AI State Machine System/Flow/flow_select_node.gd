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
	var found=false
	for node in condition_state_nodes:
		if node.check_for_condition():
			switch_state(self,node)
			found=true
	if !found:
		print(str("One of the condition nodes needs to meet the condition on Flow Select Node ",name))

func check_for_conditions_met():
	pass 
