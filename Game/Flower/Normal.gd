extends Node2D

func OnTreeEntered():
	get_parent().get_node("Anim").play("IDLE")
