class_name EnemyStateMachine

extends Node

signal chase_ended

enum State {
	IDLE,
	CHASE,
	PATROL,
	ATTACK
}

var current_state: State = State.IDLE
var previous_state:= current_state

var data: EnemyFodderData

func update() -> void:
	var prev = current_state
	if data.player_detected and data.in_attack_range:
		current_state = State.ATTACK
	elif data.player_detected and not data.in_attack_range:
		current_state = State.CHASE
	else:
		current_state = State.PATROL
	
	if prev == State.CHASE and current_state != State.CHASE:
		emit_signal("chase_ended")
		
func force_state(new_state: State) -> void:
	if current_state == new_state:
		return

	previous_state = current_state
	current_state = new_state
