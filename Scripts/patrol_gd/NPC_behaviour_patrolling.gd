@tool
extends Node2D


@export var walk_speed: float = 5.5

var patrol_location: Array[PatrolLocation]
var current_location_index: int = 0
var target: PatrolLocation

# Called when the node enters the scene tree for the first time.
func _ready():
	gather_patrol_locations()
	if Engine.is_editor_hint():
		child_entered_tree.connect(gather_patrol_locations)
		child_order_changed.connect(gather_patrol_locations)
	pass # Replace with function body.
	# super()

func gather_patrol_locations(_n: Node = null):
	patrol_location = []
	for c in get_children():
		if c is PatrolLocation:
			patrol_location.append(c)


func start()->void:
	pass