extends Node2D

export(int) var Range = 300
export(int) var Damage = 10
export(float) var AttackSpeed = 1.0

var AttackCounter = 0.0

func _process(delta):
	pass

func OnTreeEntered():
	get_parent().get_node("Anim").play("GLITCH")
