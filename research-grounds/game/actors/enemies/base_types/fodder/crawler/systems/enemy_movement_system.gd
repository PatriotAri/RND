class_name EnemyMovementSystem

extends Node

#references
var body: CharacterBody2D
var data: EnemyFodderData
var detection_system: DetectionSystem

#patrol variables
var patrol_origin: Vector2
var patrol_offsets: Array[Vector2] = []
var patrol_points: Array[Vector2] = []
var current_patrol_index:= 0
@export var patrol_wait_time:= 3.5
var patrol_timer:= 0.0

#attack variables
var attack_performed:= false
var attack_recovery_time:= 1.5
var attack_recovery_timer:= 0.0

func setup(p_body: CharacterBody2D) -> void:
	body = p_body
	patrol_offsets.clear()
	if body.has_node("PatrolPoints"):
		for child in body.get_node("PatrolPoints").get_children():
			patrol_offsets.append(child.position)
	reset_patrol_origin(body.global_position)

func update(delta: float) -> void:
	#reads the flag set by state machine
	if data.state_just_changed:
		_on_state_changed(data.previous_state, data.current_state)

	match data.current_state:
		EnemyStateMachine.State.PATROL:
			patrol(delta)
		EnemyStateMachine.State.CHASE:
			chase(delta)
		EnemyStateMachine.State.ATTACK:
			attack(delta)
		_:
			idle(delta)

func idle(_delta: float) -> void:
	body.velocity = Vector2.ZERO
	body.move_and_slide()

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

func reset_patrol_origin(new_origin: Vector2) -> void:
	patrol_origin = new_origin
	current_patrol_index = 0
	patrol_timer = 0.0
	body.velocity = Vector2.ZERO
	patrol_points.clear()
	for offset in patrol_offsets:
		patrol_points.append(patrol_origin + offset)

func chase(_delta: float) -> void:
	if not detection_system.has_player():
		body.velocity = Vector2.ZERO
		body.move_and_slide()
		return
	var target_pos := detection_system.get_player_position()
	var direction := (target_pos - body.global_position).normalized()
	body.velocity = direction * data.walk_speed
	body.move_and_slide()

func attack(delta: float) -> void:
	body.velocity = Vector2.ZERO
	body.move_and_slide()
	if not attack_performed:
		body.perform_melee_attack()
		attack_performed = true
	attack_recovery_timer += delta
	if attack_recovery_timer >= attack_recovery_time:
		attack_recovery_timer = 0.0
		attack_performed = false

func _on_state_changed(from: EnemyStateMachine.State, to: EnemyStateMachine.State) -> void:
	if to == EnemyStateMachine.State.ATTACK:
		attack_recovery_timer = 0.0
		attack_performed = false
	if from == EnemyStateMachine.State.CHASE:
		reset_patrol_origin(body.global_position)
