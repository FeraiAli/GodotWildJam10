extends Node

signal ToNormal
signal ToAnomaly
	
func Glitch(glitch):
	for node in get_tree().get_nodes_in_group(glitch):
		emit_signal("ToAnomaly")

func TrySolution(solution):
	for node in get_tree().get_nodes_in_group(solution):
		emit_signal("ToNormal")
	
func _input(event):
	if event.is_action_pressed("ui_page_up"):
		Glitch("Rabbit")
	if event.is_action_pressed("ui_page_down"):
		TrySolution("Rabbit")

func GetPlayer():
	return get_tree().get_nodes_in_group("Player").front()