extends Node2D
class_name AttackComponent

signal attacked

@export var base_damage: int = 10
@export var attack_range: float = 100.0
@export var attack_cooldown: float = 0.7


var can_attack: bool = true

func _ready():
	pass


func Attack(target) -> void:
	if can_attack:
		if is_target_inrange(target):
			if target.has_node("HealthComponent"):
				# this is the health component that is damaged of the target
				var target_health_component = target.get_node("HealthComponent")
				await get_tree().create_timer(0.2).timeout
				apply_damage(target_health_component)
				can_attack = false
				emit_signal("attacked", target) # this is the name of the target that was attacked
				await get_tree().create_timer(attack_cooldown).timeout
				can_attack = true


func apply_damage(target) -> void:
	if target.has_method("take_damage"):
		print("target has method take_damage")
		target.take_damage(base_damage)

func is_target_inrange(target) -> bool:
	return global_position.distance_to(target.global_position) <= attack_range

func set_attack_range(new_range: float) -> void:
	attack_range = new_range

func set_attack_cooldown(new_cooldown) -> void:
	attack_cooldown = new_cooldown
