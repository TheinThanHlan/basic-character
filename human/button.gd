extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(toggle_camera_button);




func toggle_camera_button():
	if get_viewport().get_camera_3d() == $"../../camera_controller/third_person_camera":
		$"../../camera_controller/first_person_camera".current=true
		$"../..".global_rotation.y=$"../../visuals".global_rotation.y;
		$"../../visuals".rotation.y=0;
	
		
	else:
		$"../../camera_controller/third_person_camera".current=true
	
	#print()
