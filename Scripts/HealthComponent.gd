extends Node2D
class_name HealthComponent

signal health_changed
signal died

@export var max_health: int = 200
@export var current_health: int = 200
# setget set_current_health


func _ready():
	print(current_health)
	current_health = clamp(current_health, 0, max_health)

func set_current_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	emit_signal("health_changed", current_health)
	if current_health == 0:
		emit_signal("died")


func take_damage(ammount: int, weapon_multiplier: float = 1.0) -> void:
	var definate_damage = ammount * weapon_multiplier
	set_current_health(current_health - definate_damage)

func heal(amount: int) -> void:
	set_current_health(current_health + amount)

func is_dead() -> bool:
	return current_health == 0

func fully_heal() -> void:
	set_current_health(max_health)
