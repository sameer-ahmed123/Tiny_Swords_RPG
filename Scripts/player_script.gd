# /////////////////////////////////////////////////////////////////////////////////////////////////
extends CharacterBody2D

enum state {NORMAL, HITTING}

@onready var player_sprite = $AnimatedSprite2D
@onready var hit_area = $hit_area/CollisionShape2D

#health and attack component
@onready var health_component = $HealthComponent # initalizes the healt of entity with export variables
@onready var attack_component = $AttackComponent
@onready var enemy_in_attack_area = 1

#check if enemy is in attack area then impliment the attack logic by passing the enemy to the
# attack(target) method of the attack component

var acel = 300
var is_swinging = false
var move_speed = 450.0
var currentState = state.NORMAL
var isStateNew = true
var swing_timer: float = 0.0
@export var swing_duration: float = 0.7 # Duration of the swing animation in seconds


func _ready():
	#health component signals 
	health_component.connect("died", Callable(self, "_on_death"))
	health_component.connect("health_changed", Callable(self, "_on_health_changed"))
	#attack component signals
	attack_component.connect("attacked", Callable(self, "_on_attacked"))


func _process(delta):
	match currentState:
		state.NORMAL:
			process_normal(delta)
		state.HITTING:
			process_hitting(delta)
	isStateNew = false

func changeState(newState):
	currentState = newState
	isStateNew = true

func process_normal(delta):
	var direction = get_movement_vector()
	velocity.x = move_toward(velocity.x, move_speed * direction.x, acel)
	velocity.y = move_toward(velocity.y, move_speed * direction.y, acel)

	# Change state if clicked
	# print("in state NORMAL")

	if Input.is_action_just_pressed("kys"):
		print("kys pressed")
		health_component.take_damage(10)
		

	if Input.is_action_just_pressed("swing_sword"):
		call_deferred("changeState", state.HITTING)
	
		#flipping directionally
	if direction.x > 0:
		player_sprite.flip_h = false
		hit_area.position.x = abs(hit_area.position.x) # ensures this gives positive val
	elif direction.x < 0:
		player_sprite.flip_h = true
		hit_area.position.x = -abs(hit_area.position.x) # ensures this gives negative val

	move_and_slide()

	update_animation()

func process_hitting(delta):
	# print("in state HITTING")

	# Initialize swing animation if entering the HITTING state
	if isStateNew:
		is_swinging = true
		swing_timer = swing_duration

	if is_swinging:
		hit_area.disabled = false
		player_sprite.play("swing_downwords")
		swing_timer = swing_timer - delta
		if swing_timer <= 0:
			is_swinging = false
			# print("go back to normal STATE")
	else:
		hit_area.disabled = true
		call_deferred("changeState", state.NORMAL)

	update_animation()

func update_animation():
	var direction = get_movement_vector()
	if currentState == state.NORMAL:
		if direction != Vector2.ZERO:
			if player_sprite.animation != "walk_run":
				player_sprite.play("walk_run")
		else:
			if player_sprite.animation != "idle":
				player_sprite.play("idle")

## Get direction of movement 
func get_movement_vector():
	var move_vector = Vector2.ZERO
	move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move_vector = move_vector.normalized()
	return move_vector


#Health Component Signal Funcs
func _on_death() -> void:
	print("the player has died of old age !")
	queue_free()

func _on_health_changed(current_health) -> void:
	print("curent_helth is ", current_health)

#Attack Component Signal funcs
func _on_attacked(target):

	# print("attacked an enemy")
	# print("Attacked target: %s" % target.name)
	attack_component.Attack(target)

func _on_hit_area_body_entered(_body: Node2D):
	# _on_attacked(_body)
	# print("enemy hit")
	if _body.has_node("HealthComponent"):
		var target_health_component = _body.get_node("HealthComponent")
		attack_component.Attack(target_health_component)
