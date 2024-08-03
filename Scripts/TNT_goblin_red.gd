extends CharacterBody2D

@onready var health_component = $HealthComponent

func _ready():
	health_component.connect("died", Callable(self, "_on_died"))
	health_component.connect("health_changed", Callable(self, "_on_health_changed"))


func _on_died() -> void:
	queue_free()

func _on_health_changed(current_health) -> void:
	print("tnt goblin health is ", current_health)