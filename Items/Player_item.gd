extends Node3D
class_name Player_item
signal on_primary_action
signal on_secundary_action
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func primary_action():
	_onPrimary_action()
	emit_signal("on_primary_action")
	pass
func secondary_action():
	_onSecondary_action()
	emit_signal("on_secundary_action")
	pass
func _onPrimary_action():
	pass

func _onSecondary_action():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
