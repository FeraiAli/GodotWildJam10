extends Node

func Glitch(glitch):
	for node in get_tree().get_nodes_in_group(glitch):
		node.ToAnomaly()

func TrySolution(solution):
	for node in get_tree().get_nodes_in_group(solution):
		node.ToNormal()
	
func _input(event):
	var TestMalfunction = "Rabbit"
	if event.is_action_pressed("ui_page_up"):
		Glitch(TestMalfunction)
	if event.is_action_pressed("ui_page_down"):
		TrySolution(TestMalfunction)

func GetPlayer():
	return get_tree().get_nodes_in_group("Player").front()