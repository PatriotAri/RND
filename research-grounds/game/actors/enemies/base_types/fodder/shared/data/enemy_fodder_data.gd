class_name EnemyFodderData

#read/written by DetectionSystem
var player_detected:= false
var in_attack_range:= false

#read/written by state machine
var current_state: EnemyStateMachine.State = EnemyStateMachine.State.IDLE
var previous_state: EnemyStateMachine.State = EnemyStateMachine.State.IDLE
var state_just_changed:= false

#read/written by movement system
var patrol_speed:= 50
var walk_speed:= 65.0
var run_speed:= 130.0
var is_attacking:= false
