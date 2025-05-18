extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 12

var xform : Transform3D


func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	#play cat animations
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$AnimationPlayer.play("a_cat_run_01")
	elif is_on_floor() and input_dir != Vector2.ZERO:
		$AnimationPlayer.play("a_cat_walk_01")
	elif is_on_floor() and input_dir == Vector2.ZERO:
		$AnimationPlayer.play("a_cat_idle_01")
	
	#rotate camera left right
	if Input.is_action_just_pressed("cam_left"):
		$Camera_Controller.rotate_y(deg_to_rad(30))
	if Input.is_action_just_pressed("cam_right"):
		$Camera_Controller.rotate_y(deg_to_rad(-30))
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#new vecxtor3 direction taking account for user input cam rotation
	var direction = ($Camera_Controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#rotate cam mesh oriented towards direction in relation to camera
	if input_dir != Vector2(0,0):
		$rig_cat.rotation_degrees.y = $Camera_Controller.rotation_degrees.y - rad_to_deg(input_dir.angle()) - 90
	
	#Rotate character to allign with floor
	if is_on_floor():
		align_with_floor($RayCast3D.get_collision_normal())
		global_transform = global_transform.interpolate_with(xform, 0.3)
	elif not is_on_floor():
		align_with_floor(Vector3.UP)
		global_transform = global_transform.interpolate_with(xform, 0.3)
	
	# update volocity and move character
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	#Make Camera Controller match pos of player
	$Camera_Controller.position = lerp($Camera_Controller.position, position, 0.08)


func align_with_floor(floor_normal):
	xform = global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()
	

#if player gets touched by enemy
func _on_fall_zone_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://level_1.tscn")
	
	
	#bouncing off enemy
func bounce():
	velocity.y = JUMP_VELOCITY * 0.7
	
	
	
