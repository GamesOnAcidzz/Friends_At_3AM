extends Node3D
class_name Player_item
@export var item_name:String=""
var player_onwer:Player_controller

signal on_primary_action
signal on_secondary_action
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
