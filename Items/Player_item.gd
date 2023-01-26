extends Player_interactable
class_name Player_item

var player_onwer:Player_controller
var is_player_owned:bool = false

@export var item_name:String=""

@onready var model_pickup:MeshInstance3D  = get_node("Model_holder_pickup/Model")
@onready var model_player:MeshInstance3D  = get_node("Model_holder_player/Model")

signal on_primary_action
signal on_secondary_action
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _onInteract(player:Player_controller):
	if !is_player_owned:
		pick_item(player)
		
func pick_item(player:Player_controller):
	position=Vector3(0,0,0)
	$".".freeze=true
	model_pickup.visible=false
	model_player.visible=true
	player.add_item_to_inventory(self)
	
func primary_action():
	_onPrimary_action()
	emit_signal("on_primary_action")
	pass
func secondary_action():
	_onSecondary_action()
	emit_signal("on_secondary_action")
	pass
func _onPrimary_action():
	pass

func _onSecondary_action():
	pass
func set_player_owner(player:Player_controller):
	player_onwer=player
	
func clear_player_owner():
	player_onwer=null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
