extends Player_interactable
class_name Player_item_interactable

#@export var player_item_scene:PackedScene 
@export_node_path(Player_item) var Player_item_path

@onready var player_item_holder:Node3D = get_node("Player_item_holder")
#@onready var player_item_node:Node3D = player_item_scene.instantiate()


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _onInteract(player:Player_controller):
	var item = player_item_holder.get_child(0)
	player_item_holder.remove_child(item)
	player.add_item_to_inventory(item)
	queue_free()
	pass
