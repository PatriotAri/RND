class_name EnemyMovementSystem

extends Node

#references
var body: CharacterBody2D
var data: EnemyFodderData
var state_machine: EnemyStateMachine
var detection_system: DetectionSystem

#patrol variables
var patrol_origin: Vector2
var patrol_offsets: Array[Vector2] = []
var patrol_points: Array[Vector2] = []
var current_patrol_index:= 0
@export var patrol_wait_time:= 3.5
var patrol_timer:= 0.0

#attack variables
var attack_performed:= false  # Track if we've attacked this cycle
var attack_recovery_time:= 1.5  # Cooldown after attack
var attack_recovery_timer:= 0.0
var last_state: EnemyStateMachine.State

func setup(p_body: CharacterBody2D) -> void:
	body = p_body

	patrol_offsets.clear()
	if body.has_node("PatrolPoints"):
		for child in body.get_node("PatrolPoints").get_children():
			#store local offsets
			patrol_offsets.append(child.position)

	#initial patrol anchored to spawn position
	reset_patrol_origin(body.global_position)

#runs local function associated with current state
func update(delta: float) -> void:
	if state_machine.current_state != last_state:
		_on_state_changed(last_state, state_machine.current_state)
		last_state = state_machine.current_state
	
	match state_machine.current_state:
		EnemyStateMachine.State.PATROL:
			patrol(delta)
		EnemyStateMachine.State.CHASE:
			chase(delta)
		EnemyStateMachine.State.ATTACK:
			attack(delta)
		_:
			idle(delta)

#idle function
func idle(delta: float) -> void:
	body.velocity = Vector2.ZERO
	body.move_and_slide()

#patrol function
func patrol(delta: float) -> void:
	if patrol_points.is_empty():
		body.velocity = Vector2.ZERO
		body.move_and_slide()
		return

	var target_pos := patrol_points[current_patrol_index]
	var direction := target_pos - body.global_position

	if direction.length() < 5.0:
		patrol_timer += delta
		body.velocity = Vector2.ZERO

		if patrol_timer >= patrol_wait_time:
			patrol_timer = 0.0
			current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
	else:
		body.velocity = direction.normalized() * data.patrol_speed

	body.move_and_slide()

#reset origin/patrol points after chase
func reset_patrol_origin(new_origin: Vector2) -> void:
	patrol_origin = new_origin
	current_patrol_index = 0
	patrol_timer = 0.0
	
	body.velocity = Vector2.ZERO
	
	patrol_points.clear()
	for offset in patrol_offsets:
		patrol_points.append(patrol_origin + offset)

#chase function
func chase(delta: float) -> void:
	if not detection_system.has_player():
		body.velocity = Vector2.ZERO
		body.move_and_slide()
		return

	var target_pos := detection_system.get_player_position()
	var direction := (target_pos - body.global_position).normalized()
	body.velocity = direction * data.walk_speed
	body.move_and_slide()
	
#attack function
func attack(delta: float) -> void:
	# Stop moving during attack
	body.velocity = Vector2.ZERO
	body.move_and_slide()
	
	# Perform attack once
	if not attack_performed:
		body.perform_melee_attack()  # Call the attack!
		attack_performed = true
		print("Enemy attacked!")  # Debug
	
	# Recovery phase
	attack_recovery_timer += delta
	if attack_recovery_timer >= attack_recovery_time:
		# Attack cycle complete - state machine will handle transition
		pass

func _on_state_changed(from: EnemyStateMachine.State, to: EnemyStateMachine.State) -> void:
	# Reset attack timers when entering attack state
	if to == EnemyStateMachine.State.ATTACK:
		attack_recovery_timer = 0.0
		attack_performed = false
