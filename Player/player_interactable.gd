extends Node3D
class_name Player_interactable

@export var interaction_text = ""
@export_node_path(Area3D) var collision_path
@onready var collisionArea:Area3D = get_node(collision_path)

signal onInteract
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	_onInteract()
	emit_signal("onInteract")
	
func _onInteract():
	pass
