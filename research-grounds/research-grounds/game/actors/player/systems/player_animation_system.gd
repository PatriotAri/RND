class_name PlayerAnimationSystem

#holds reference to player AnimatedSprite2D, null until first assigned on initialization.
var sprite: AnimatedSprite2D
#stores most recent animation name played
var _last_animation: String = ""

#runs once when class is instanced.
#Receives players AnimatedSprite2D and stores the reference.
func _init(sprite_ref: AnimatedSprite2D) -> void:
	sprite = sprite_ref

#runs every frame because its called in player._physics_process()
func update(data: PlayerData) -> void:
	
	var animation_name := _resolve_animation(data)
	
	#if animation_name isnt equal to the last animation then
	if animation_name != _last_animation:
		#play the animation name
		sprite.play(animation_name)
		#sets the value of _last_animation to the current animation_name
		_last_animation = animation_name

#turns state + facing into an animation name string
func _resolve_animation(data: PlayerData) -> String:
	var dir := _facing_to_string(data.facing_dir)
	
	#Checks current state_name in player_data.
	if data.state_name == "walk":
		if data.is_running:
			return "run_" + dir
		else:
			return "walk_" + dir
	else:
		return "idle_" + dir

#maps a facing direction vector to a cardinal string
func _facing_to_string(facing: Vector2) -> String:
	
	#gives the variable the value of the facing direction converted to radian angles
	var angle := facing.angle()

	# Convert radians to degrees for human readability
	var degrees := rad_to_deg(angle)

	#Vector2.angle() automatically considers -180 to 180 to be the degrees in this range.
	#if degrees are below 0, we add 360 to convert it to a positive measurement.
	if degrees < 0:
		degrees += 360

	#check each angle slice the value falls into, wawthen returns string associated with angle.
	if degrees >= 337.5 or degrees < 22.5:
		return "right"
	elif degrees < 67.5:
		return "down_right"
	elif degrees < 112.5:
		return "down"
	elif degrees < 157.5:
		return "down_left"
	elif degrees < 202.5:
		return "left"
	elif degrees < 247.5:
		return "up_left"
	elif degrees < 292.5:
		return "up"
	else:
		return "up_right"
