extends CharacterBody3D

		 
const SPEED = 1.31
const JUMP_VELOCITY = 6
const RUNNING_SPEED= 5;

var push_force=10;
var mouse_sensitivity:=0.01;

@onready var ani=$visuals/man/AnimationPlayer;

func _ready():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED;
	

	
#change mouse mode
func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		if(Input.mouse_mode==Input.MOUSE_MODE_VISIBLE):
			Input.mouse_mode=Input.MOUSE_MODE_CAPTURED;
			
		else:
			Input.mouse_mode=Input.MOUSE_MODE_VISIBLE;

	#if(event is InputEventMouseButton):
	#	if(event.button_index==MOUSE_BUTTON_WHEEL_UP):
	#		$camera_controller/third_person_camera.global_position.x+=1
	#	if(event.button_index==MOUSE_BUTTON_WHEEL_DOWN):
	#		$camera_controller/third_person_camera.global_position.x-=1




func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		ani.play("jump");
			
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#ani.play("Armature|mixamo_com|Layer0");
		velocity.y = JUMP_VELOCITY
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	
	if is_on_floor():
		#walking
		if direction and !Input.is_key_pressed(KEY_SHIFT):
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			ani.play("walk")						
			
		#running
		elif Input.is_key_pressed(KEY_SHIFT) and direction:
			velocity.x = direction.x * RUNNING_SPEED
			velocity.z = direction.z * RUNNING_SPEED
			ani.play("runx");
			
			
			
		#idle
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			ani.play("idlex")
		
		
		if get_viewport().get_camera_3d()==$"camera_controller/third_person_camera" && position!=position+direction:
			$visuals.look_at(position+direction)		
	move_and_slide();
	
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x* mouse_sensitivity)
		var pitch=-event.relative.y*mouse_sensitivity;
		$camera_controller.rotate_x(pitch);
		$camera_controller.rotation.x=clamp($camera_controller.rotation.x,deg_to_rad(-90),deg_to_rad(90))
