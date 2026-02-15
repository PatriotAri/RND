class_name PlayerInputSystem

"""
creates update function to be called 
in player.gd and write input update to PlayerData.
"""
func update(data: PlayerData) -> void:
	#temporary local variables, will not set player global position
	var x := 0.0
	var y := 0.0

	#gets player input and converts to float
	if Input.is_action_pressed("player_right"):
		x += 1.0
	if Input.is_action_pressed("player_left"):
		x -= 1.0
	if Input.is_action_pressed("player_down"):
		y += 1.0
	if Input.is_action_pressed("player_up"):
		y -= 1.0
		
	#combines x and y floats and stores it as a vector
	var move_vector := Vector2(x, y)

	#if not moving then lerp input (normalizes diagonal movement)
	if move_vector != Vector2.ZERO:
		move_vector = move_vector.normalized()
		
	#sets move_vector in PlayerData to move vector from InputSystem
	data.move_vector = move_vector

	#run intent(if "player_run" is pressed than is_running is True)
	data.is_running = Input.is_action_pressed("player_run")
	
	#attack intent
	data.is_attacking = Input.is_action_just_pressed("attack")
