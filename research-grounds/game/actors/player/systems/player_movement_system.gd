class_name PlayerMovementSystem

var player: CharacterBody2D

func _init(player_ref: CharacterBody2D) -> void:
	player = player_ref

"""
Writes to player data, currently delta is here to future 
proof any desired changes to speed like acceleration, 
deceleration, knockback, etc.
"""
func update(data: PlayerData, delta: float) -> void:
	#.velocity is a property native to CharacterBody2D.
	player.velocity = data.move_vector * data.current_move_speed
	
	if data.is_attacking:
		player.velocity = Vector2.ZERO

	#Moves "player"(characterBody2D) using its velocity and resolves collisions by sliding.
	player.move_and_slide()
