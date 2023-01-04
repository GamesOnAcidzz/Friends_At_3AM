extends Control
class_name Connection_lost_menu

signal go_back
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_go_back_pressed():
	emit_signal("go_back")
	self.queue_free()
	# Replace with function body.
