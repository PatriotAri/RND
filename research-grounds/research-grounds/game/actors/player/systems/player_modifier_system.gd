class_name PlayerModifierSystem

func update(data: PlayerData, delta: float) -> void:
	_resolve_movement_speed(data)
	
func _resolve_movement_speed(data: PlayerData) -> void:
	if data.is_running:
		#sets current speed to run speed
		data.current_move_speed = data.base_run_speed
	else:
		#sets current speed to walk speed
		data.current_move_speed = data.base_walk_speed
