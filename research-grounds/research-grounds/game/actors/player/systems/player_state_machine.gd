class_name PlayerStateMachine

#writes updated state and facing direction to PlayerData
func update(data: PlayerData) -> void:
	_resolve_state(data)
	_resolve_facing(data)

#reads move_vector from PlayerData
func _resolve_state(data: PlayerData) -> void:
	
	#sets symbolic movement STATE based on move_vector from PlayerData
	if data.move_vector == Vector2.ZERO:
		data.state_name = "idle"
	else:
		data.state_name = "walk"

#reads move_vector from PlayerData
func _resolve_facing(data: PlayerData) -> void:
	
	#sets FACING direction based on move_vector from PlayerData
	if data.move_vector != Vector2.ZERO:
		data.facing_dir = data.move_vector
