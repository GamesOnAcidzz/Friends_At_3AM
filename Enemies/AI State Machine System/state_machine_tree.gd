extends Node
class_name State_Machine_Tree

@onready var ai_controller:AI_Controller=get_parent()
@onready var state_manager:State_Manager=get_node("State Manager")
@onready var blackboard:AI_State_Machine_Blackboard=get_node("Blackboard")
# Called when the node enters the scene tree for the first time.
func _ready():
	state_manager.ai_controller=ai_controller
	pass # Replace with function body.
func get_blackboard()->AI_State_Machine_Blackboard:
	var blackboard = get_node("Blackboard")
	return blackboard


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
