extends Node
class_name AI_State_Machine_Blackboard

@export var keys:Dictionary = {"KeyName":false}
@onready var keys2:Dictionary= {"KeyName":false}
# Called when the node enters the scene tree for the first time.
func _ready():
	print(keys.has("Test"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
