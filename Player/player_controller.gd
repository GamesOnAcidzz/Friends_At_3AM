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

@onready var pivot_camera = get_node("SpringArm3D")
@onready var inventory = get_node("Inventory")

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