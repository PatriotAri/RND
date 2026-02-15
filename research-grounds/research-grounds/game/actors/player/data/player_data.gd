class_name PlayerData

#read/written by InputSystem (player intent)
var move_vector:= Vector2.ZERO
var is_running:= false
var is_attacking:= false

#direction and state labels created from intent
#read/written by StateMachine 
var state_name:= "idle"
var facing_dir:= Vector2.DOWN

#movement stats
#read/written by ModifierSystem
var base_walk_speed:= 100.0
var base_run_speed:= 140.0
var current_move_speed:= 100.0
