extends Node
class_name State_Machine_Tree
@export_node_path("NavigationAgent3D") var navigation_agent_node_path
@export_node_path("CharacterBody3D") var character_body_3d_node_path

@onready var ai_controller:AI_Controller=get_parent()
@onready var state_manager:State_Manager=get_node("State Manager")

# Called when the node enters the scene tree for the first time.
func _ready():
	state_manager.ai_controller=ai_controller
	pass # Replace with function body.
func get_blackboard()->AI_State_Machine_Blackboard:
	return get_node("Blackboard")
	
func get_navigation_agent_3d()->NavigationAgent3D:
	return get_node(navigation_agent_node_path)
	
func get_character_body_3d()->CharacterBody3D:
	return get_node(character_body_3d_node_path)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
