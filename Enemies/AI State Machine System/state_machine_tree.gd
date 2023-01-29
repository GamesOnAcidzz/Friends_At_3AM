extends Node
class_name State_Machine_Tree

@onready var enemy_controller:Enemy_Controller=get_parent()
@onready var state_manager:State_Manager=get_node("State Manager")
# Called when the node enters the scene tree for the first time.
func _ready():
	state_manager.enemy_controller=enemy_controller
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
