extends CharacterBody2D

enum state {NORMAL, PATROL, CHASING, HITTING, DEATH}
@onready var health_component = $HealthComponent


var isStateNew = true
var currentState = state.NORMAL


func _ready():
	health_component.connect("died", Callable(self, "_on_died"))
	health_component.connect("health_changed", Callable(self, "_on_health_changed"))


func _process(delta):
	match currentState:
		state.NORMAL:
			process_normal(delta)
		state.PATROL:
			process_patrol(delta)
		state.CHASING:
			process_chasing(delta)
		state.HITTING:
			process_hitting(delta)
		state.DEATH:
			process_death(delta)
	isStateNew = false
	

func changeState(newState):
	currentState = newState
	isStateNew = true


func process_normal(_delta):
	pass

func process_patrol(_delta):
	pass

func process_chasing(_delta):
	pass

func process_hitting(_delta):
	pass

func process_death(_delta):
	pass


#Health Component Signal Funcs
func _on_died() -> void:
	print("the goblin enemy has died")
	queue_free()

func _on_health_changed(current_health) -> void:
	print("curent_helth of GOBLIN is ", current_health)
