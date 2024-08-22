class_name npcBEHAVIOUR extends Node2D

var npc: NPC

func _ready():
	var p = get_parent()
	if p is NPC:
		npc = p as NPC
		#connect to signal
		npc.do_behaviour_enabled.connect(start)


func start() -> void:
	pass