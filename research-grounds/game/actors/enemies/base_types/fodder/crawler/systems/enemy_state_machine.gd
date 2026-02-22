class_name EnemyStateMachine

enum State {
	IDLE,
	CHASE,
	PATROL,
	ATTACK
}

func update(data: EnemyFodderData) -> void:
	var new_state := _resolve_state(data)

	if new_state != data.current_state:
		data.previous_state = data.current_state
		data.current_state = new_state
		data.state_just_changed = true
	else:
		data.state_just_changed = false

func _resolve_state(data: EnemyFodderData) -> State:
	if data.player_detected and data.in_attack_range:
		return State.ATTACK
	elif data.player_detected:
		return State.CHASE
	else:
		return State.PATROL
