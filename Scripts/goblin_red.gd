extends CharacterBody2D


@onready var health_component = $HealthComponent

func _ready():
	health_component.connect("died", Callable(self, "_on_died"))
	health_component.connect("health_changed", Callable(self, "_on_health_changed"))


#Health Component Signal Funcs
func _on_died() -> void:
	print("the goblin enemy has died")
	queue_free()

func _on_health_changed(current_health) -> void:
	print("curent_helth of GOBLIN is ", current_health)
