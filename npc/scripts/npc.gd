@tool
class_name NPC extends CharacterBody2D

signal do_behaviour_enabled

var state: String = "idle"
var direction: Vector2 = Vector2.DOWN
var direction_name: String = "down"
var do_behavior: bool = true

@export var npc_resource: NPC_RESOURCE: set = _set_npc_resource
	
@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer


func _ready():
	setup_NPC()
	if Engine.is_editor_hint():
		return
	do_behaviour_enabled.emit()
	
func _process(delta):
	move_and_slide()

func update_animation():
	animation.play(state + "_" + direction_name)

func update_direction(target_position: Vector2):
	direction = global_position.direction_to(target_position)
	update_direction_name()
	if direction_name == "side" and direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func update_direction_name():
	var threshold: float = 0.45
	if direction.y < -threshold:
		direction_name = "up"
	elif direction.y > threshold:
		direction_name = "down"
	elif direction.x > threshold or direction.x < -threshold:
		direction_name = "side"
func setup_NPC() -> void:
	if npc_resource != null:
		if sprite:
				sprite.texture = npc_resource.sprite

func _set_npc_resource(_npc: NPC_RESOURCE):
	npc_resource = _npc
	setup_NPC()
