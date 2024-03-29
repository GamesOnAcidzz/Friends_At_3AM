extends CharacterBody3D
class_name Player_controller

@export var mouse_sensitivity:float=0.2

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var input_dir:Vector2 = Vector2(0,0)
var direction
var is_running=false
var can_run=true
var max_intentory_size=2

@onready var animation_controller:AnimationTree = get_node("AnimationTree")
@onready var interact_area:Area3D = get_node("Interact_Area")
@onready var pivot_camera = get_node("SpringArm3D")
@onready var inventory = get_node("Inventory")
@onready var item_holder = get_node("Player_character/Character/Skeleton3D/BoneAttachment3D/Item_holder")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
			velocity.y -= gravity * delta
	if is_running and can_run:
		input_dir = Vector2(0,-1)
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
		if direction:
			velocity.z = direction.z*(-SPEED*2)
			velocity.x = direction.x*(-SPEED*2)
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*2)
			velocity.z = move_toward(velocity.z, 0, SPEED*2)
	else:
		input_dir = Input.get_vector("left", "right", "forward", "backward")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()		
		if direction:
			velocity.x = direction.x * -SPEED
			velocity.z = direction.z * -SPEED
		else:

			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
func _input(event):
	if event is InputEventMouseMotion:
		rotation.y-=deg_to_rad(event.relative.x * mouse_sensitivity)
		pivot_camera.rotate_x(deg_to_rad(event.relative.y * mouse_sensitivity))
		pivot_camera.set_rotation(Vector3(clamp(pivot_camera.get_rotation().x,deg_to_rad(-30),deg_to_rad(10)),0,0))
	if Input.is_action_pressed("Run",true):
		is_running=true
	else:
		is_running=false
	if Input.is_action_just_pressed("Interact",true):
		if (!interact_area.get_overlapping_bodies().is_empty()):
			interact_area.get_overlapping_bodies()[0].interact(self)
	if (item_holder.get_child_count()!=0):
		if Input.is_action_just_pressed("Primary"):
			item_holder.get_child(0).primary_action()
		if Input.is_action_just_pressed("Secondary"):
			item_holder.get_child(0).secondary_action()
		if Input.is_action_just_pressed("Drop"):
			drop_item()
		if Input.is_action_just_pressed("Next item"):
			next_item()
		if Input.is_action_just_pressed("Previous item"):
			previous_item()
			

func equip_item(item:Player_item):
	item.set_player_owner(self)
	item.get_parent().remove_child(item)
	item_holder.add_child(item)
	animation_controller.set("parameters/Basic Player Control/BlendTree/Item_blend/blend_amount",1)
	#animation_controller.set("parameters/Basic Player Control/BlendTree/Transition/current",item_holder.get_child(0).item_name)
func add_item_to_inventory(item:Player_item)->bool:
	if (inventory.get_child_count()<max_intentory_size):
		if (item_holder.get_child_count()==0):
			equip_item(item)
			return true
		else:
			item.set_player_owner(self)
			item.get_parent().remove_child(item)
			inventory.add_child(item)
			return true
	return false
func drop_item():
	if (item_holder.get_child_count()!=0):
		var player_item:Player_item = item_holder.get_child(0)
		player_item.drop_item(self)
		player_item.position = position+(global_transform.basis.z*3)
		item_holder.remove_child(player_item)
		get_parent_node_3d().add_child(player_item)
		animation_controller.set("parameters/Basic Player Control/BlendTree/Item_blend/blend_amount",0)
		if inventory.get_child_count()!=0:
			var player_item_inventory = inventory.get_child(0)
			inventory.remove_child(player_item_inventory)
			item_holder.add_child(player_item_inventory)
			animation_controller.set("parameters/Basic Player Control/BlendTree/Item_blend/blend_amount",1)
func next_item():
	if inventory.get_child_count()!=0:
		var player_item = item_holder.get_child(0)
		item_holder.remove_child(player_item)
		inventory.add_child(player_item)
		var player_item_inventory = inventory.get_child(0)
		inventory.remove_child(player_item_inventory)
		item_holder.add_child(player_item_inventory)
	
func previous_item():
	if inventory.get_child_count()!=0:
		var player_item = item_holder.get_child(0)
		item_holder.remove_child(player_item)
		var player_item_inventory = inventory.get_child(inventory.get_child_count()-1)
		inventory.remove_child(player_item_inventory)
		item_holder.add_child(player_item_inventory)
		inventory.add_child(player_item)
	
