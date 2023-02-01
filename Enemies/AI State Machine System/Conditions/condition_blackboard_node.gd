extends Condition_State_Node
class_name Condition_Blackboard_Boolean_Node

@export var key_Name:String = ""
@export var is_set=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_for_condition()->bool:
	if (state_manager.state_machine_tree.blackboard.keys.has(key_Name)):
		if (state_manager.state_machine_tree.blackboard.keys.get(key_Name)==is_set):
			return true
		else:
			return false
	else:
		print (str("Key not found on node ",name))
		return false
