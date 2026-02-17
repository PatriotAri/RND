extends CharacterBody2D

#import packed global scenes
var global_packed_scenes:= GlobalPackedScenes

#type casts DetectionArea as DetectionSystem, allows script to send signals
@onready var detection_system: DetectionSystem = $DetectionArea as DetectionSystem
var enemy_state_machine: EnemyStateMachine
@onready var movement_system: EnemyMovementSystem = $MovementSystem as EnemyMovementSystem

#health and damage components
@onready var health = $HealthComponent

#hitbox variables
@export_group("Hitbox Variables")
@export_subgroup("Hitbox Type")
@export var melee_hitbox_scene = global_packed_scenes.melee_attack_hitbox
@export_subgroup("Attack Tuning")
@export var melee_attack_distance:= 20
@export var windup_time:= 0.5   # Enemy windup
@export var lifetime:= 0.3       # How long hitbox stays active
@export var damage:= 10.0    # Damage done by enemy

var data: EnemyFodderData

func _ready() -> void:
	#listens for the signal "died" emitting from HealthComponent, 
	#then connects the _on_died method to run when it does emit.
	health.died.connect(_on_died)
	data = EnemyFodderData.new()
	
	#injects shared data
	detection_system.data = data
	enemy_state_machine = EnemyStateMachine.new()
	movement_system.data = data
	
	detection_system.body = self
	
	movement_system.setup(self)
	movement_system.detection_system = detection_system
	
func _physics_process(delta: float) -> void:
	#temp code, shows player targetting works
	detection_system.update()
	enemy_state_machine.update(data)
	movement_system.update(delta)
	
func _on_chase_ended() -> void:
	movement_system.reset_patrol_origin(global_position)

#instance melee hitbox
func perform_melee_attack():
	print("Enemy attacking!")
	#instances hitbox scene
	var hitbox = melee_hitbox_scene.instantiate()
	
	# NEW: Configure hitbox to hit player (layer 5 = bit value 16)
	hitbox.target_layer = 16
	
	# Override timing values for enemy attacks
	hitbox.windup_time = windup_time   # Enemy windup (adjust as needed)
	hitbox.lifetime = lifetime       # How long hitbox stays active
	hitbox.damage = damage        # Enemy damage (adjust as needed)
	
	#adds scene to world
	add_child(hitbox)
	
	#positions hitbox relative to enemy
	var direction = sign(scale.x)
	hitbox.position = Vector2(melee_attack_distance * direction, 0)

#kills the character
func _on_died():
	#queues node to be deleted at end of frame
	queue_free()
