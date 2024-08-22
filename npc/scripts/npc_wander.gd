@tool
extends npcBEHAVIOUR

@onready var collisionShape = $CollisionShape2D

const DIRECTIONS = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]

@export var wander_range: int = 2: set = _set_wander_range
@export var wander_speed: float = 30.0
@export var wander_duration: float = 1.0
@export var idle_duration: float = 1.0

var original_position: Vector2


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super()
	collisionShape.queue_free()
	original_position = npc.global_position

func start() -> void:
	if npc.do_behavior == false:
		return
	
	#idle phase
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()
	await get_tree().create_timer(randf() * idle_duration + idle_duration * 0.5).timeout
	
	#WALK Phase
	npc.state = "walk"
	var _dir: Vector2 = DIRECTIONS[randi_range(0, 3)]
	npc.direction = _dir
	npc.velocity = wander_speed * _dir
	npc.update_direction(global_position + _dir)
	npc.update_animation()
	await get_tree().create_timer(randf() * wander_duration + wander_duration * 0.5).timeout

	#REPEAT
	if npc.do_behavior == false:
		return
	start()
	

func _set_wander_range(v: int) -> void:
	wander_range = v
	# collisionShape.shape.radius = v * 32.0
    # ☝️ the above comented  line should work even when un comentedd - gives error:
        # Invalid get index 'shape' (on base: 'Nil')
