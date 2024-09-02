@tool
class_name PatrolLocation extends Node2D

@onready var lable = $Sprite2D/Label
@onready var lable2 = $Sprite2D/Label2
@onready var patrol_location_sprite = $Sprite2D

@export var wait_time: float = 0.0:
	set(v):
		wait_time = v
		_update_wait_time_lable()

var target_position: Vector2 = Vector2.ZERO


func _ready():
	target_position = global_position
	_update_wait_time_lable()
	if Engine.is_editor_hint():
		return
	patrol_location_sprite.queue_free()
	

func update_lable(string):
	lable.text = string


func update_line(next_location: Vector2):
	var line: Line2D = $Sprite2D/Line2D
	line.points[1] = next_location - position


func _update_wait_time_lable() -> void:
	if Engine.is_editor_hint():
		lable2.text = "wait: " + str(snappedf(wait_time, 0.1)) + "s"
